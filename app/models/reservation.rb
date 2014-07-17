class Reservation < ActiveRecord::Base
  include ReservationValidations
  include ReservationScopes

  has_paper_trail

  belongs_to :equipment_model
  belongs_to :equipment_object
  belongs_to :reserver, class_name: 'User'
  belongs_to :checkout_handler, class_name: 'User'
  belongs_to :checkin_handler, class_name: 'User'

  validates :equipment_model, :start_date, :due_date, presence: true
  validate :start_date_before_due_date
  validate :matched_object_and_model
  validate :not_in_past, :available, on: :create

  nilify_blanks only: [:notes]

  attr_accessible :checkout_handler_id,
                  :checkin_handler_id, :approval_status,
                  :checked_out, :checked_in, :equipment_object,
                  :equipment_object_id, :notes, :notes_unsent, :times_renewed,
                  :reserver_id, :reserver, :start_date, :due_date,
                  :equipment_model_id

  def duration
    due_date.to_date - start_date.to_date + 1
  end

  def self.number_for_model_on_date(date,model_id,source)
    # count the number of reservations that overlaps a date within
    # a given array of source reservations and that matches
    # a specific model id
    #
    # this code is used largely in validations because it uses 0 queries
    count = 0
    source.each do |r|
      count += 1 if r.start_date <= date && r.due_date >= date && r.equipment_model_id == model_id
    end
    count
  end

  def self.number_for_category_on_date(date,category_id,reservations)
    count = 0
    reservations.each do |r|
      count += 1 if r.start_date <= date && r.due_date >= date && r.equipment_model.category_id == category_id
    end
    return count
  end

  def self.number_overdue_for_eq_model(model_id, reservations)
    # count the number of overdue reservations for a given
    # eq model out of an array of source reservations
    #
    # used in rendering the catalog in order to save db queries
    #
    # 0 queries
    count = 0
    reservations.each do |r|
      count += 1 if r.status == 'overdue' && r.equipment_model_id == model_id
    end
    count
  end


  def reserver
    User.find(self.reserver_id)
  rescue
    #if user's been deleted, return a dummy user
    User.new( first_name: "Deleted",
              last_name: "User",
              login: "deleted",
              email: "deleted.user@invalid.address",
              nickname: "",
              phone: "555-555-5555",
              affiliation: "Deleted")
  end

  def validate
    # Convert reservation to a cart object and run validations on it
    # For hard validations, use reservation.valid
    self.to_cart.validate_all
  end

  def validate_renew
    self.to_cart.validate_all(true)
  end

  def status
    if checked_out.nil?
      if approval_status == 'auto' or approval_status == 'approved'
        due_date >= Date.today ? "reserved" : "missed"
      elsif approval_status
        approval_status
      else
        "?" # ... is this just in case an admin does something absurd in the database?
      end
    elsif checked_in.nil?
      due_date < Date.today ? "overdue" : "checked out"
    else
      due_date < checked_in.to_date ? "returned overdue" : "returned on time"
    end
  end

  def checkout_object_uniqueness(reservations)
    object_ids_taken = []
    reservations.each do |r|
      return false if object_ids_taken.include?(r.equipment_object_id)
      object_ids_taken << r.equipment_object_id
    end
    return true # return true if unique
  end

  def late_fee
    self.equipment_model.late_fee.to_f
  end

  def fake_reserver_id # this is necessary for autocomplete! delete me not!
  end

  def max_renewal_length_available
    # determine the max renewal length for a given reservation
    # O(n) queries

    orig_due_date = self.due_date
    eq_model = self.equipment_model
    eq_model.maximum_renewal_length.downto(0).each do |r|
      self.due_date = orig_due_date + r.days
      if self.validate_renew.empty? && (eq_model.num_available(orig_due_date+1.day, self.due_date) > 0)
        self.due_date = orig_due_date
        return r
      end
    end
    return 0
  end

  def is_eligible_for_renew?
    # determines if a reservation is eligible for renewal, based on how many days before the due
    # date it is and the max number of times one is allowed to renew
    #
    self.times_renewed ||= 0

    # you can't renew a checked in reservation, or one without an equipment model
    return false if self.checked_in || self.equipment_object.nil?

    max_renewal_times = self.equipment_model.maximum_renewal_times
    max_renewal_times = Float::INFINITY if max_renewal_times == 'unrestricted'

    max_renewal_days = self.equipment_model.maximum_renewal_days_before_due
    max_renewal_days = Float::INFINITY if max_renewal_days == 'unrestricted'
    return ((self.due_date.to_date - Date.today).to_i < max_renewal_days ) &&
      (self.times_renewed < max_renewal_times)
  end

  def renew
    # renew the reservation and return error messages if unsuccessful
    return "Reservation not eligible for renewal" unless self.is_eligible_for_renew?
    self.due_date += self.max_renewal_length_available.days
    return "Unable to update reservation dates!" unless self.save
    return nil
  end

  def to_cart
    temp_cart = Cart.new
    temp_cart.start_date = self.start_date
    temp_cart.due_date = self.due_date
    temp_cart.reserver_id = self.reserver_id
    temp_cart.items = { self.equipment_model_id => 1 }
    temp_cart
  end
end
