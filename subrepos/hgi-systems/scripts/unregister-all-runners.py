#!/usr/bin/env python3
from typing import Tuple

from gitlab import Gitlab, GitlabDeleteError
import argparse
import sys


def get_settings_from_cli_arguments() -> Tuple[str, str]:
    """
    Gets settings from CLI arguments.
    :return:
    """
    parser = argparse.ArgumentParser(description="Delete all runners on GitLab")
    parser.add_argument("--url", type=str, help="Location of GitLab")
    parser.add_argument("--token", type=str, help="GitLab access token")
    args = parser.parse_args()
    return args.url, args.token


def delete_all_runners(gitlab_url: str, token: str):
    """
    Deletes all runners in the specified GitLab.
    :param gitlab_url: the location of GitLab
    :param token: the token used to access GitLab
    """
    connector = Gitlab(gitlab_url, token)

    runners = connector.runners.list(all=True)
    projects = connector.projects.list(all=True)

    for runner in runners:
        # GitLab won't let us remove a runner until it's no longer associated to a project
        for project in projects:
            if runner.id in {runner.id for runner in project.runners.list(all=True)}:
                try:
                    project.runners.delete(runner.id)
                except GitlabDeleteError as e:
                    if "Only one project associated with the runner" in e.error_message:
                        break
                    else:
                        raise
        try:
            description = runner.description
            runner.delete()
            print("Deleted: %s" % description, file=sys.stderr)
        except Exception as e:
            print(e, file=sys.stderr)


def main():
    url, token = get_settings_from_cli_arguments()
    delete_all_runners(url, token)


if __name__ == "__main__":
    main()
