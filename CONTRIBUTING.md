# Contributing to Reservations

Thanks so much for helping with the development of Reservations! This guide will cover the process for helping out with the project and should allow you to get started quickly and easily. If you need any help with contributing, please e-mail `stc-reservations{at}yale{dot}edu` to contact the core team.

## Reporting an Issue
If you've been using Reservations and [notice a bug](#bug-reports), or want to [suggest a new feature](#feature-requests), please open a [GitHub issue](https://github.com/YaleSTC/reservations/issues/new). Before doing so, however, please **search open / closed issues** to see if someone else has already opened a similar issue.

### Bug Reports
A bug is a *verifiable problem* that is caused by the Reservations code. Good bug reports allow us to quickly identify the root causes of problems and resolve them. Here are some guidelines for submitting bug reports:

1. **Is it a duplicate?** - check to see if the bug has already been reported.
2. **Has it been resolved?** - check if it can be reproduced using the `master` branch or a newer version.
3. **What is the problem?** - see if you can isolate exactly how to reproduce the issue.
4. **Include a screenshot or screencast** - you can use [LICEcap](http://www.cockos.com/licecap/) to capture a screencast and save it as an animated gif.
5. **Tell us all the things** - include as much information as possible (see the template below for a good starting point).

#### Bug Report Template (thanks [Ghost](https://github.com/TryGhost/Ghost) team!)
```
Short and descriptive example bug report title

### Issue Summary

A summary of the issue and the browser/OS environment in which it occurs. If
suitable, include the steps required to reproduce the bug.

### Steps to Reproduce

1. This is the first step
2. This is the second step
3. Further steps, etc.

Any other information you want to share that is relevant to the issue being
reported. Especially, why do you consider this to be a bug? What do you expect to happen instead?

### Technical details:

* Reservations Version: vX.X.X OR master (a1b2c3)
* Operating System: Mac OS X 10.5.1
* Browser: Chrome 39.0.2171.71
```

A member of the core team will label your issue appropriately and may follow up for more information. We try to deal with bugs as quickly as possible and will keep the issue updated with our progress, but it may take some time before it is resolved.

### Feature Requests
Feature requests are always welcome as well. Before submitting a feature request, please search both opened and closed issues to see if the feature has already been requested. Remember that it's up to *you* to convince the core team of the merits of the feature. Please include as much detail as possible, including but not limited to the use case, a proposed implementation, and why it is likely to be common.

## Improving Documentation
One great way of helping out is improving documentation, which can take the form of user-, developer- , and sysadmin-facing documentation. Our user-facing documentation is located on our GitHub Pages [site](https://yalestc.github.io/reservations), while our developer- and sysadmin-facing documentation is located in code comments and our GitHub [wiki](https://github.com/YaleSTC/reservations/wiki).

The easiest way to make small improvements to our user-facing documentation is by editing the file with the online GitHub editor: browse the [`gh-pages` branch](https://github.com/YaleSTC/reservations/tree/gh-pages), choose the file you want to edit, click the "Edit" button, make changes, and follow the GitHub instructions from there. Once your changes are merged they will immediately appear on the website.

If you'd like to help comment our codebase to make it more easily understandable, we ideally try to use the [YARD](https://github.com/lsegal/yard) tool for consistency and ease of use. That said, any documentation is helpful so feel free to add comments where you feel necessary. If you'd like to suggest changes to the wiki please [open up an issue](https://github.com/YaleSTC/reservations/issues/new) and let us know what you think should be changed.

## Contributing Code
Helping to improve the Reservations codebase is **great**. In general, we only accept pull requests for changes related to an open GitHub issue, so make sure you open one (and it's approved) before you start working. This also makes it easier to review and test your work. The following is an overview of how to work on Reservations:

### Fork Reservations / Create a Branch
Each developer working on Reservations should fork the core Reservations repository and clone it as a local repository. Remember to add the core repository as a remote:

```
git remote add upstream git@github.com:YaleSTC/Reservations.git
```

You can either work off the forked `master` branch or create a separate topic branch in your forked repository. Make sure you pull in the latest changes from `upstream` if you cloned a while ago (`git pull upstream master`)We generally recommend prefixing the branch name with the GitHub issue number and including a few descriptive words, i.e. `1234_brief_issue_description`.

We generally maintain release branches for minor versions (e.g. `release-v3.4`) for patching purposes - if you're working on a version-specific bug make sure you branch off of the correct place.

### Testing
Make sure to update or add to the test suite where appropriate; patches and features will not be accepted without tests. We use [RSpec](http://rspec.info/) for general testing and [Capybara](http://jnicklas.github.io/capybara/) for integration testing.

### Code / Style Conventions
We use [Rubocop](http://batsov.com/rubocop/) as the arbiter of style for Reservations. You should run `rubocop -D` to ensure that all of your changes match the project conventions. We occasionally allow exceptions from code complexity violations; you should make any such request in the GitHub pull request comments.

### Merge Conflicts / Commit Squashing
TODO: Look at Ghost guide, flesh out this section

You must resolve any merge conflicts before your pull request will be reviewed. Additionally,

### Development Setup

### Contribution Workflow

### Conventions / Style