# pending-pr [![Build Status](https://secure.travis-ci.org/banyan/pending-pr.png?branch=master)](http://travis-ci.org/banyan/pending-pr)

`pending-pr` is cli tool which handles pending pull requests.

## Motivation

In a recent project, We had 500 pull requests in a month, with scattered repositories.
If repository is only one or two, it's not a problem. But we had API, client, and plugins, and lots of others.
That's why I created `pending-pr`, it's a small cli tool focusing only pending pull requests.

## Getting Started

Install the module with: `npm install pending-pr`

```
$ pending-pr init
```

## Usage

```
  Commands:

    init                 Create .pending-pr config file.
    list                 Show mergeble pull requests. Short-cut: l
    count                Show mergeble pull requests size. Short-cut: c
    ping                 Ping to pull request to be merged. Short-cut: p
    open                 Browse pull request. Short-cut: o
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

### Test

```
$ grunt test
```

## License
Copyright (c) 2013 Kohei Hasegawa
Licensed under the MIT license.
