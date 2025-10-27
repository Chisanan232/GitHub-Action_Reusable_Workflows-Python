import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Sidebar for the Docs section
 */
const sidebars: SidebarsConfig = {
  docs: [
    {
      type: 'doc',
      id: 'introduction',
      label: '📖 Introduction',
    },
    {
      type: 'category',
      label: '🚀 Quick Start',
      collapsed: false,
      items: [
        {
          type: 'doc',
          id: 'quick-start/quick-start',
          label: '⚡ Getting Started',
        },
        {
          type: 'doc',
          id: 'quick-start/requirements',
          label: '📋 Requirements',
        },
        {
          type: 'doc',
          id: 'quick-start/installation',
          label: '💾 Installation',
        },
        {
          type: 'doc',
          id: 'quick-start/how-to-run',
          label: '▶️ How to Run',
        },
      ],
    },
    {
      type: 'category',
      label: '⚙️ Configuration',
      collapsed: false,
      items: [
        {
          type: 'doc',
          id: 'configuration/configuration',
          label: '📝 Configuration Guide',
        },
        {
          type: 'doc',
          id: 'configuration/examples',
          label: '💡 Examples',
        },
      ],
    },
    {
      type: 'category',
      label: '🔧 Reusable Workflows',
      collapsed: false,
      items: [
        {
          type: 'doc',
          id: 'workflows/workflows-overview',
          label: '📚 Overview',
        },
        {
          type: 'category',
          label: '🧪 Testing Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/test/rw_get_tests',
              label: 'Get Tests',
            },
            {
              type: 'doc',
              id: 'workflows/test/rw_run_test',
              label: 'Run Test',
            },
            {
              type: 'doc',
              id: 'workflows/test/rw_poetry_run_test',
              label: 'Poetry Run Test',
            },
            {
              type: 'doc',
              id: 'workflows/test/rw_run_test_with_multi_py_versions',
              label: 'Multi-Version Test',
            },
            {
              type: 'doc',
              id: 'workflows/test/rw_poetry_run_test_with_multi_py_versions',
              label: 'Poetry Multi-Version Test',
            },
          ],
        },
        {
          type: 'category',
          label: '📊 Coverage Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/coverage_report/rw_organize_test_cov_reports',
              label: 'Organize Coverage',
            },
            {
              type: 'doc',
              id: 'workflows/coverage_report/rw_upload_test_cov_report',
              label: 'Upload Coverage',
            },
          ],
        },
        {
          type: 'category',
          label: '📦 Build & Deploy Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/build_and_deploy/rw_python_package',
              label: 'Python Package Build',
            },
            {
              type: 'doc',
              id: 'workflows/build_and_deploy/rw_push_pypi',
              label: 'PyPI Publish',
            },
            {
              type: 'doc',
              id: 'workflows/build_and_deploy/rw_pre-building_test',
              label: 'Pre-Building Test',
            },
            {
              type: 'doc',
              id: 'workflows/build_and_deploy/rw_checking_deployment_state',
              label: 'Check Deployment State',
            },
          ],
        },
        {
          type: 'category',
          label: '🐳 Docker Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/docker/rw_docker_operations',
              label: 'Docker Operations',
            },
          ],
        },
        {
          type: 'category',
          label: '📚 Documentation Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/document/rw_docs_operations',
              label: 'Docs Operations',
            },
            {
              type: 'doc',
              id: 'workflows/document/rw_documentation_deployment',
              label: 'Docs Deployment',
            },
          ],
        },
        {
          type: 'category',
          label: '🔧 Configuration Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/configuration/rw_parse_project_config',
              label: 'Parse Project Config',
            },
            {
              type: 'doc',
              id: 'workflows/configuration/rw_parse_release_intent',
              label: 'Parse Release Intent',
            },
          ],
        },
        {
          type: 'category',
          label: '🏷️ Git & Release Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/git_tag_and_github_release/rw_build_git-tag_and_create_github-release',
              label: 'Git Tag & Release',
            },
            {
              type: 'doc',
              id: 'workflows/git_tag_and_github_release/rw_build_git-tag_and_create_github-release_v2',
              label: 'Git Tag & Release v2',
            },
          ],
        },
        {
          type: 'category',
          label: '🔍 Code Quality Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/code_quality/rw_sonarqube_scan',
              label: 'SonarQube Scan',
            },
          ],
        },
        {
          type: 'category',
          label: '🔄 Release Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/release-intent-configuration',
              label: '📝 Intent Configuration',
            },
            {
              type: 'doc',
              id: 'workflows/rw_release_validation_complete',
              label: '✅ Validation Release',
            },
            {
              type: 'doc',
              id: 'workflows/rw_release_staging_complete',
              label: '🧪 Staging Release',
            },
            {
              type: 'doc',
              id: 'workflows/rw_release_complete',
              label: '🚀 Production Release',
            },
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '👋 Welcome to Contribute',
      items: [
        {
          type: 'doc',
          id: 'contribute/contribute',
          label: '🤝 Contribute',
        },
        {
          type: 'doc',
          id: 'contribute/report-bug',
          label: '🐛 Report Bug',
        },
        {
          type: 'doc',
          id: 'contribute/request-changes',
          label: '💡 Request Changes',
        },
        {
          type: 'doc',
          id: 'contribute/discuss',
          label: '💬 Discuss',
        },
      ],
    },
    {
      type: 'doc',
      id: 'changelog',
      label: '📝 Changelog',
    },
  ],
};

export default sidebars;
