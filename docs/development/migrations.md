# Creating migrations

If something needs to change, create a migration by creating tasks to perform the migration.

Then tag those tasks as with a `# MIGRATION vX.X` comment.

The next tagged release after the version in the comment, these tasks will be removed.

## Example

Gitea had an incorrect path in it's docker-compose yml file. It was pointing the `/data`
mount at `/var/lab/homelabos/gitea` instead of `/var/homelabos/gitea` where it should have been.

So two tasks were created, one to copy the folder to it's proper place, the next to make sure the
old folder was absent. The first task will fail if the folder to be copied doesn't exist, which
will be the case for new users, or users who have already ran the migration once. So `ignore_errors:
true` is included.

```
# MIGRATION v0.5
- name: Migrate old folders if needed
  shell: mv /var/lab/homelabos/gitea /var/homelabos/gitea
  ignore_errors: true

- name: Migrate old folders if needed
  file: path=/var/lab state=absent

# END MIGRATION
```