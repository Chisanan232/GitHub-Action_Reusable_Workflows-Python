# GitHub Action - Workflow template for Python library

[![Release](https://img.shields.io/github/release/Chisanan232/GitHub-Action-Template-Python.svg?label=Release&logo=github)](https://github.com/Chisanan232/GitHub-Action-Template-Python/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?logo=apache)](https://opensource.org/licenses/Apache-2.0)
[![GitHub Action reusable workflow build](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/ci-cd.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/ci-cd.yaml)

🤖 Test state:

| Usage scenario / state                                                                                                                                                                                                                                                                                                                                             |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [![Python project CI Test (one-test)](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_python_project_ci_one-test.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_python_project_ci_one-test.yaml)                                                       |
| [![Python project CI Test (multi-tests)](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_python_project_ci_multi-tests.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_python_project_ci_multi-tests.yaml)                                              |
| [![Python project with Poetry CI Test (multi-tests)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_pyproject_ci_multi-tests_by_poetry.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_pyproject_ci_multi-tests_by_poetry.yaml)                      |
| [![GitHub Action reusable workflow project CI Test](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_gh_reusable_workflow.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Workflow-Template-Python/actions/workflows/test_gh_reusable_workflow.yaml)                                                     |
| [![End-to-End test about checking deployment state](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_checking_deployment_ci.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_checking_deployment_ci.yaml)                                               |
| [![Nested Python project with Poetry CI Test (multi-tests)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_nested_pyproject_ci_multi-tests_by_poetry.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/actions/workflows/test_nested_pyproject_ci_multi-tests_by_poetry.yaml) |


This is a GitHub Action workflow template for **_Python library_** project.

[Overview](#overview) | [Workflow template usages](#workflow-template-usages)
<hr>

## Overview

In development of Python library, it configures the mostly same CI/CD processes again and again. That's the reason why I consider and implement 
this project. This project has some workflow templates for reusing in GitHub Action CI/CD processes so that it could reach some benefits:
* Be more clear what thing to do in a job.
* Be more clear and simpler of entire CI/CD work flow.
* Be easier to read and configure at configurations of GitHub Action work flow.
* It has greatly improved the GitHub Action configuration to be more reusable in multiple different projects (git repositories).


## Workflow template usages

The usage of each workflow template.

* [_rw_get_tests.yaml_](#rw_get_testsyaml)
* [_rw_run_test.yaml_](#rw_run_testyaml)
* [_rw_poetry_run_test.yaml_](#rw_poetry_run_testyaml)
* [_rw_run_test_with_multi_py_versions.yaml_](#rw_run_test_with_multi_py_versionsyaml)
* [_rw_poetry_run_test_with_multi_py_versions.yaml_](#rw_poetry_run_test_with_multi_py_versionsyaml)
* [_rw_organize_test_cov_reports.yaml_](#rw_organize_test_cov_reportsyaml)
* [_rw_upload_test_cov_report.yaml_](#rw_upload_test_cov_reportyaml)
* [_rw_pre-building_test.yaml_](#rw_pre-building_testyaml)
* [_rw_checking_deployment_state.yaml_](#rw_checking_deployment_stateyaml)
* [_rw_build_git-tag_and_create_github-release.yaml_](#rw_build_git-tag_and_create_github-releaseyaml)
* [_rw_push_pypi.yaml_](#rw_push_pypiyaml)

<hr>


### _rw_get_tests.yaml_

* Description: Prepare the test items.
* Options:

| option name          | data type | optional or required                                       | function content                                          |
|----------------------|-----------|------------------------------------------------------------|-----------------------------------------------------------|
| shell_path           | string    | Optional, Default value is _./scripts/ci/get-all-tests.sh_ | The path shell script for getting the testing items.      |
| shell_arg            | string    | Required                                                   | Input arguments of the shell script.                      |
| use_customized_shell | boolean   | Optional, Default value is _false_                         | Whether it should use the customized shell script or not. |

* Output: 
  * all_test_items: All the test items it would run.

* How to use it?

  * Use default shell script (recommended)

    If we want to use default shell script to auto-scan all tests, it only needs to give a shell script argument which is the directory path of test code:

    ```yaml
      prepare-testing-items_unit-test:
    #    name: Prepare all unit test items
        uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_get_tests.yaml@master
        with:
          shell_arg: test/unit_test/
    ```

    And it would get all tests you need. And the keyword to get this workflow output result is _all_test_items_.

  * Use customized shell script

    Before use this workflow, it should prepare a shell script for getting the testing items.

    ```yaml
      prepare-testing-items_unit-test:
    #    name: Prepare all unit test items
        uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_get_tests.yaml@master
        with:
          shell_path: scripts/ci/get-unit-test-paths.sh
          shell_arg: unix
          use_customized_shell: true
    ```

    And we could get this workflow output result via keyword _all_test_items_.

<hr>

### _rw_run_test.yaml_

* Description: Run testing by specific type with all test items via PyTest and generate its testing coverage report (it would save reports by _actions/upload-artifact_).
* Options:

| option name             | data type | optional or required                       | function content                                                                           |
|-------------------------|-----------|--------------------------------------------|--------------------------------------------------------------------------------------------|
| runtime_os              | string    | Optional, Default value is _ubuntu-latest_ | The OS to use for runtime environment.                                                     |
| python_version          | string    | Optional, Default value is _3.11_          | The Python version to run the test in workflow.                                            |
| test_type               | string    | Required                                   | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |
| all_test_items_paths    | string    | Required                                   | The target paths of test items under test.                                                 |
| setup_http_server       | string    | Optional, Default value is _false_         | If it's true, it would set up and run HTTP server for testing.                             |
| http_server_host        | string    | Optional, Default value is _0.0.0.0_       | The host IPv4 address of HTTP server.                                                      |
| http_server_port        | string    | Optional, Default value is _12345_         | The port number of HTTP server.                                                            |
| http_server_app_module  | string    | Optional, Default value is _app_           | The module path of HTTP server.                                                            |
| http_server_enter_point | string    | Optional, Default value is _app_           | The object about the web application.                                                      |
| debug_mode              | boolean   | Optional, Default value is _false_         | For debug, so it's matrix would only has one os: ubuntu-22.04 & one python-version: 3.10.  |

* Output: 

No, but it would save the testing coverage reports to provide after-process to organize and record.

| Upload-Artifact name | description                                                                                                                                                                                          |
|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| coverage             | The test coverage report which be generated by PyTest, and it's recorded after run test done. The file name format would be .coverage.<inputs.test type>.<matrix.runtime os>-<matrix.python version> |

* How to use it?

```yaml
  run_unit-test:
#    name: Run all unit test items
    needs: prepare-testing-items_unit-test
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_run_test.yaml@master
    with:
      python_version: '3.10'
      test_type: unit-test
      all_test_items_paths: ${{needs.prepare-testing-items_unit-test.outputs.all_test_items}}
      setup_http_server: true
      http_server_host: 0.0.0.0
      http_server_port: 30303
      http_server_app_module: test._http_server.app
      http_server_enter_point: app
```

Please take a look of option _all_test_items_paths_. You could find that it get the input result of 
previous workflow _prepare-testing-items_unit-test_ via below way:

    ${{needs.prepare-testing-items_unit-test.outputs.all_test_items}}

Character part _needs.prepare-testing-items_unit-test_ means it want to get something context info 
from needed workflow _prepare-testing-items_unit-test_, and the context it wants to get is _outputs_. 
And be more essentially, what outputs it want to use? It's _all_test_items_. Do you discover this keyword 
is provided by previous workflow? That is all testing items.

> **_NOTE:_**
>
> It also has another reusable workflow names _poetry_run_test_via_pytest.yaml_. If your Python project manages by **Poetry**, 
> it recommends you to use this one replaces _rw_run_test.yaml_. The usage and running details are mostly same 
> as _rw_run_test.yaml_. But, workflow _poetry_run_test_via_pytest.yaml_ only supports Python version 3.8 up. 
>


<hr>

### _rw_poetry_run_test.yaml_

* Description: Same working with workflow _rw_run_test.yaml_, but this workflow would run test via **_Poetry_**.

* Difference between workflows _rw_run_test.yaml_ and _poetry_run_test_via_pytest.yaml_:

| Workflow                          | Running way                                       |
|-----------------------------------|---------------------------------------------------|
| _rw_run_test.yaml_                | Command lines like ``pip``, ``python``, etc       |
| _poetry_run_test_via_pytest.yaml_ | Use ``poetry`` feature or run command lines in it |

And for the poetry reusable workflow, it has 3 parameters another doesn't have:

| Workflow                           | Running way                                                                                                                                                    |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| _test_working_directory_           | The working directory for test running.                                                                                                                        |
| _install_dependency_with_group_    | Install the dependency by Poetry configuration with dependency group setting. This parameter receive the dependency group naming. (multiple values allowed)    |
| _install_dependency_without_group_ | Install the dependency by Poetry configuration without dependency group setting. This parameter receive the dependency group naming. (multiple values allowed) |


<hr>

### _rw_run_test_with_multi_py_versions.yaml_

* Description: Almost same working with workflow _rw_run_test.yaml_, but it would run test with multiple Python versions
with multiple runtime environment OS.


<hr>

### _rw_poetry_run_test_with_multi_py_versions.yaml_

* Description: Almost same working with workflow _rw_poetry_run_test.yaml_, but it would run test with multiple Python versions
with multiple runtime environment OS.

* Difference between workflows _rw_run_test_with_multi_py_version.yaml_ and _rw_poetry_run_test_with_multi_py_versions.yaml_

 | Workflow                                         | Running way                                       | Support Python version |
 |--------------------------------------------------|---------------------------------------------------|------------------------|
 | _rw_run_test_with_multi_py_version.yaml_         | Command lines like ``pip``, ``python``, etc       | 3.6 - 3.11             |
 | _rw_poetry_run_test_with_multi_py_versions.yaml_ | Use ``poetry`` feature or run command lines in it | 3.8 - 3.11             |


<hr>

### _rw_organize_test_cov_reports.yaml_

* Description: Organize all the testing coverage reports which be generated in different runtime OS with Python version. (it would save reports by _actions/upload-artifact_).
* Options:

| option name | data type | optional or required | function content                                                                           |
|-------------|-----------|----------------------|--------------------------------------------------------------------------------------------|
| test_type   | string    | Required             | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |

* Output: 

No, but it would save the testing coverage reports to provide after-process to organize and record.

| Upload-Artifact name     | description                                                                                                     |
|--------------------------|-----------------------------------------------------------------------------------------------------------------|
| test_coverage_report     | The handled test coverage report (.coverage file). It's file name format would be .coverage.<inputs.test type>. |
| test_coverage_xml_report | The handled test coverage report (.xml file). It's file name format would be coverage_<inputs.test type>.xml.   |

* How to use it?

```yaml
  unit-test_codecov:
#    name: Organize and generate the testing report and upload it to Codecov
    needs: run_unit-test
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_organize_test_cov_reports.yaml@master
    with:
      test_type: unit-test
```

It would upload the organized report via _actions/upload-artifact_. And it doesn't support customize options of _actions/upload-artifact_ currently.

<hr>

### _rw_upload_test_cov_report.yaml_

* Description: Upload the testing coverage reports to Codecov.
* Options:

It has 2 different types option could use:

_General option_:

| option name         | data type | optional or required                     | function content                                                                                                    |
|---------------------|-----------|------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| download_path       | string    | Optional. Default value is './'.         | The path to download testing coverage reports via _actions/download-artifact_.                                      |
| test_type           | string    | Required                                 | The testing type. In generally, it only has 3 options: _unit-test_, _integration-test_ and _all-type_.              |
| upload-to-codecov   | boolean   | Optional. Default value is _false_.      | If it's true, it would upload testing coverage report for Codecov (https://codecov.io).                             |
| codecov_flags       | string    | Optional. Default value is empty string. | The flags of the testing coverage report for Codecov. This option would be required if _upload-to-codecov_ is true. |
| codecov_name        | string    | Optional. Default value is empty string. | The name of the testing coverage report for Codecov. This option would be required if _upload-to-codecov_ is true.  |
| upload-to-coveralls | boolean   | Optional. Default value is _false_.      | If it's true, it would upload testing coverage report for Coveralls (https://coveralls.io).                         |
| upload-to-codacy    | boolean   | Optional. Default value is _false_.      | If it's true, it would upload testing coverage report for Codacy (https://app.codacy.com/).                         |

_Secret option_:

| option name     | option is optional or required           | function content                                                                                                                  |
|-----------------|------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| codecov_token   | Optional. Default value is empty string. | The API token for uploading testing coverage report to Codecov. This option would be required if _upload-to-codecov_ is true.     |
| coveralls_token | Optional. Default value is empty string. | The API token for uploading testing coverage report to Coveralls. This option would be required if _upload-to-coveralls_ is true. |
| codacy_token    | Optional. Default value is empty string. | The API token for uploading testing coverage report to Codacy. This option would be required if _upload-to-codacy_ is true.       |

* Output: 

Nothing.

* How to use it?

   ⚠️ Before run this reusable workflow, please make sure testing coverage report is ready.<br>

   ❔What format of test coverage report it could use? Different platform would need different format. But basically, it only accepts 2 types: _.coverage_ & _.xml_. 
   
   👀 This reusable work flow would check the input parameters first. The specific platform token shouldn't be empty where uploading flag is true. 

    * Uploading test coverage report to **_Codecov_** (accepted report format: _.xml_)

        In Codecov case, it would need other 2 necessary options _codecov_flags_ & _codecov_name_.

        ```yaml
          codecov_finish:
        #    name: Organize and generate the testing report and upload it to Codecov
            needs: [unit-test_codecov]
            uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_upload_test_cov_report.yaml@master
            secrets:
              codecov_token: ${{ secrets.CODECOV_TOKEN }}
            with:
              test_type: unit-test
              upload-to-codecov: true
              codecov_flags: unittests # required if upload-to-codecov is true
              codecov_name: smoothcrawler-cluster_github-actions_test # required if upload-to-codecov is true
        ```
      
        The badge it generates: 
        
        [![codecov](https://codecov.io/gh/Chisanan232/GitHub-Action_Reusable_Workflows-Python/branch/master/graph/badge.svg?token=wbPgJ4wxOl)](https://codecov.io/gh/Chisanan232/GitHub-Action_Reusable_Workflows-Python)

    * Uploading test coverage report to **_Coveralls_** (accepted report format: _.coverage_)

        In Coveralls case, the Python tool _coveralls_ only accept _.coverage_ type report so that it would do coverage process again (integrate all test types report into one report).

        ```yaml
          codecov_finish:
        #    name: Organize and generate the testing report and upload it to Coveralls
            needs: [unit-test_codecov]
            uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_upload_test_cov_report.yaml@master
            secrets:
              coveralls_token: ${{ secrets.COVERALLS_TOKEN }}
            with:
              test_type: unit-test
              upload-to-coveralls: true
        ```
      
        The badge it generates: 
        
        [![Coverage Status](https://coveralls.io/repos/github/Chisanan232/GitHub-Action_Reusable_Workflows-Python/badge.svg?branch=master)](https://coveralls.io/github/Chisanan232/GitHub-Action_Reusable_Workflows-Python?branch=master)

    * Uploading test coverage report to **_Codacy_** (accepted report format: _.xml_) 

        In Codacy case, please use **CODACY_PROJECT_TOKEN**, not **CODACY_API_TOKEN**.

        ```yaml
          codecov_finish:
        #    name: Organize and generate the testing report and upload it to Codacy
            needs: [unit-test_codecov]
            uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/rw_upload_test_cov_report.yaml@master
            secrets:
              codacy_token: ${{ secrets.CODACY_PROJECT_TOKEN }}
            with:
              test_type: unit-test
              upload-to-codacy: true
        ```
      
        The badge it generates: 
        
        [![Codacy Badge](https://app.codacy.com/project/badge/Grade/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Chisanan232/GitHub-Action-Template-Python&amp;utm_campaign=Badge_Grade)
        [![Codacy Badge](https://app.codacy.com/project/badge/Coverage/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&utm_medium=referral&utm_content=Chisanan232/GitHub-Action-Template-Python&utm_campaign=Badge_Coverage)

<hr>

### _rw_pre-building_test.yaml_

* Description: Test package by simple way after running setup.py script to install Python package
* Options:

| option name          | data type | optional or required                      | function content                                    |
|----------------------|-----------|-------------------------------------------|-----------------------------------------------------|
| build-type           | string    | Optional, Default value is _setuptools_   | The way CI should run the pre-build test.           |
| python_package_name  | string    | Required                                  | The Python package name.                            |
| test_shell           | string    | Optional, Default value is _empty string_ | Run command line(s) for testing.                    |
| test_shell_in_python | string    | Optional, Default value is _empty string_ | Run Python code as script for testing.              |
| test_python_script   | string    | Optional, Default value is _empty string_ | Run a Python script for testing the Python package. |

* Output: 

No, nothing at all.

* How to use it?

```yaml
  rw_pre-building_test:
#    name: Check about it could work finely by installing the Python package with setup.py file
    uses: ./.github/workflows/rw_pre-building_test.yaml
    with:
      build-type: setuptools
      python_package_name: Test-GitHub-Action-workflow
      test_shell_in_python: from test_gh_workflow import sample
      test_shell: echo 'Echo something for testing'
      test_python_script: ./scripts/ci/test/test_pgk_install.py
```

<hr>

### _rw_checking_deployment_state.yaml_

* Description: Before truly deployment, e.g., release and push Python package to PyPI, it would check the release
relative information to judge whether it should release or not. 
* Requirement: The target project must has one Python module named **_\_\_pkg_info\_\_.py_**. And the content of it
should be like following:
```python
__version__ = "0.2.3"
```
* How to trigger it?: 

It would use the package info module to get the current Package version info. And it would also try to install the 
Python package from PyPI to get the latest version of it. Finally, it would use this 2 version info to compare whether 
the project current version is same as the version in PyPI or not. If it is, it would skip. But if it isn't, it would 
start to run deployment process to release.

> [!NOTE]
> For the newborn project, it won't be released to PyPI before, it 
> would set its software version as 0.0.0 at default.       

* Trigger condition:

  1. Python file **_\_\_pkg_info\_\_.py_** has been updated.
  2. The property **_\_\_version\_\__** has been updated. (aka the software version value)
  3. The software version value is different with the version in PyPI.

* Options:

| option name              | data type | optional or required               | function content                                                                                         |
|--------------------------|-----------|------------------------------------|----------------------------------------------------------------------------------------------------------|
| working-directory        | string    | Optional, Default value is _./_    | The working directory for this CI running.                                                               |
| library-name             | string    | Required                           | The target library name for checking the version info.                                                   |
| library-source-code-path | string    | Required_                          | The source code path of target library to check.                                                         |
| library-default-version  | string    | Optional, Default value is _0.0.0_ | The default value of software version if it cannot get the software version info from installed library. |

* Output: 

Yes, it has running result output. It would output the updating state about whether the version has been updated or not.
And the CI workflow after-process could use this output result to judge whether it should run the deployment process or not.

| Upload-Artifact name | description                                                                                   |
|----------------------|-----------------------------------------------------------------------------------------------|
| version_update_state | The version update state. It only has 2 states: **VERSION UPDATE** and **NO VERSION UPDATE**. |

* How to use it?

    * **_cd.yaml_** usage case:

    ```yaml
    name: CD
    
    on:
      # Run the deployment about publishing the Python source code to PyPI.
      push:
        branches:
          - "master"
        paths:
    #     This deployment workflow would only be triggered by file change of module *__pkg_info__* because it has the package version info.
    #      - ".github/workflows/cd.yaml"    # For test or emergency scenario only
          - "**/__pkg_info__.py"
    
    jobs:
      check_version-state:
    #    name: Check the version update state
        uses: ./.github/workflows/rw_checking_deployment_state.yaml
        with:
          library-name: your-python-package-name
          library-source-code-path: ./your_source_code_directory
    
      push_python_pkg_to_pypi:
    #    name: Check about it could work finely by installing the Python package with setup.py file
        needs: check_version-state
        if: ${{ needs.check_version-state.outputs.version_update_state == 'VERSION UPDATE' }}
        uses: ./.github/workflows/rw_push_pypi.yaml
        with:
          build-type: poetry
          release-type: ${{ needs.build_git-tag_and_create_github-release.outputs.python_release_version }}
          push-to-PyPI: official
        secrets:
          PyPI_user: ${{ secrets.PYPI_USERNAME }}
          PyPI_token: ${{ secrets.PYPI_PASSWORD }}
    ```

The badge it generates: 

[![Release](https://img.shields.io/github/release/Chisanan232/GitHub-Action-Template-Python.svg?label=Release&logo=github)](https://github.com/Chisanan232/GitHub-Action-Template-Python/releases)

<hr>


### _rw_build_git-tag_and_create_github-release.yaml_

* Description: Build a git tag on a specific commit in every git branch. And create GitHub release if current git branch is 'master'.
* Options:

| option name             | data type | optional or required                      | function content                                                                                                                                                     |
|-------------------------|-----------|-------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| project_type            | string    | Required                                  | Different project type would get the software version info in different way. Currently, it only has 2 options: _python-package_ or _github-action-reusable-workflow_ |
| debug_mode              | boolean   | Optional, Default value is _false_        | It would run the tasks as log message, doesn't essentially run feature if this option is true.                                                                       |
| project_name            | string    | Optional, Default value is _empty string_ | The project name.                                                                                                                                                    |
| software_version_format | string    | Optional, Default value is _empty string_ | The format of software version.                                                                                                                                      |

* Output: 

Yes, it has running result output. It would output the version which could provide after-process to verify what thing it should do, e.g., release or not.

| Workflow output                                 | description                                                                                          |
|-------------------------------------------------|------------------------------------------------------------------------------------------------------|
| python_release_version                          | Python project release version info. It only has 2 types value: _Official-Release_ or _Pre-Release_. |
| github-action_reusable_workflow_release_version | Python project release version info.                                                                 |

* How to use it?

    * **_Python package_** usage case:

    ```yaml
      rw_build_git-tag_and_create_github-release:
    #    name: Build git tag and GitHub release if it needs for Python package project
        needs: [coveralls_finish, codacy_finish]
        uses: ./.github/workflows/rw_build_git-tag_and_create_github-release.yaml
        with:
          project_type: python-package
          project_name: test_gh_workflow
          software_version_format: general-3
          debug_mode: true
    ```

    * **_GitHub Action reusable workflow_** usage case:

    ```yaml
      rw_build_git-tag_and_create_github-release:
    #    name: Build git tag and GitHub release if it needs for GitHub Action reusable workflow project
        needs: [coveralls_finish, codacy_finish]
        uses: ./.github/workflows/rw_build_git-tag_and_create_github-release.yaml
        with:
          project_type: github-action-reusable-workflow
          debug_mode: true
    ```

The badge it generates: 

[![Release](https://img.shields.io/github/release/Chisanan232/GitHub-Action-Template-Python.svg?label=Release&logo=github)](https://github.com/Chisanan232/GitHub-Action-Template-Python/releases)

<hr>

### _rw_push_pypi.yaml_

* Description: Compile source code and push the Python package to PyPI. (Official release the Python package)
* Options:

It has 2 different types option could use:

_General option_:

| option name  | data type | optional or required                      | function content                                                                                                                                     |
|--------------|-----------|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| build-type   | string    | Optional, Default value is _setuptools_   | Which way CI should to package the Python code. It has 2 type options: 'setuptools' or 'poetry'.                                                     |
| release-type | string    | Required                                  | The type of release processing. It has 2 type options: 'Official-Release' or 'Pre-Release'. It won't push the package to PyPI if it's 'Pre-Release'. |
| push-to-PyPI | string    | Optional, Default value is _empty string_ | Push Python package to official PyPI or test PyPI. It has 2 type options: 'official' or 'test'.                                                      |

_Secret option_:

| option name | option is optional or required | function content            |
|-------------|--------------------------------|-----------------------------|
| PyPI_user   | Required                       | The username of PyPI.       |
| PyPI_token  | Required                       | The password token of PyPI. |

* Output: 

No, nothing at all.

* How to use it?

```yaml
  push_python_pkg_to_pypi:
#    name: Upload the Python package files which has been compiled to PyPi
    uses: ./.github/workflows/rw_push_pypi.yaml
    with:
      build-type: setuptools
      release-type: 'Official-Release'
      push-to-PyPI: test
    secrets:
      pypi_user: ${{ secrets.PYPI_USERNAME }}
      pypi_token: ${{ secrets.PYPI_PASSWORD }}
```

