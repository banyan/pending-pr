# pending-pr [![Build Status](https://secure.travis-ci.org/banyan/pending-pr.png?branch=master)](http://travis-ci.org/banyan/pending-pr)

`pending-pr` is a CLI tool which handles pending pull requests.

## Motivation

In a recent project, We had 500 pull requests in a month, with scattered repositories.
If repository is only one or two, it's not a problem. But we had API, client, and plugins, and lots of others.
That's why I created `pending-pr`, it's a small cli tool focusing only pending pull requests.

## Getting Started

Install the module with:

```
$ npm install -g pending-pr
```

Create `.pending-pr` file with `init` command:

```
$ pending-pr init
Token: YOUR_GITHUB_OAUTH_TOKEN
Repos: foo/bar baz/qux
Members: banyan foo bar
24 Sep 00:55:20 - info: create /Users/banyan/tmp/pending-pr/.pending-pr

$ cat .pending-pr
{
    "token": "YOUR_GITHUB_OAUTH_TOKEN",
    "repos": ["foo/baz", "baz/qux"],
    "members": ["banyan", "foo", "bar"]
}
```

* `token` is your github oauth token.
* `repos` is that you'd like to check if they have pending PRs.
* `members` is that you'd like to mention to them.

## Usage

```
Commands:

    init                 Create .pending-pr config file.
    list                 Show mergeble pull requests. Short-cut: l
    count                Show mergeble pull requests size. Short-cut: c
    ping                 Ping to pull request to be merged. Short-cut: p
    open                 Browse pull request. Short-cut: o
```

## Tips

With Jenkins or cron, it can be checked whether pending PRs exists and notify regulary.

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

### Running the Tests

```
$ grunt test
```

### TODO

* Customizable message
* Configurable of unmergeble keywords

## License

Copyright (c) 2013 Kohei Hasegawa
Licensed under the MIT license.
