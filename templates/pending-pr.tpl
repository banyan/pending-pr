{
    "token": "<%= token %>",
    "repos": [<% _.each(repos, function(repo, i) { %>"<%= repo.trim() %>"<%= (repos.length - 1) === i ? '' : ', ' %><% }); %>],
    "members": [<% _.each(members, function(member, i) { %>"<%= member.trim() %>"<%= (members.length - 1) === i ? '' : ', ' %><% }); %>]
}
