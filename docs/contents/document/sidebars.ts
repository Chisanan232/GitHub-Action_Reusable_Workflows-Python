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
              id: 'workflows/rw_get_tests',
              label: 'Get Tests',
            },
            {
              type: 'doc',
              id: 'workflows/rw_run_test',
              label: 'Run Test',
            },
          ],
        },
        {
          type: 'category',
          label: '📊 Coverage Workflows',
          items: [
            {
              type: 'doc',
              id: 'workflows/rw_upload_test_cov_report',
              label: 'Upload Coverage',
            },
          ],
        },
        {
          type: 'category',
          label: '🚀 CI/CD Features',
          items: [
            {
              type: 'doc',
              id: 'workflows/cicd-overview',
              label: '📋 Overview',
            },
            {
              type: 'doc',
              id: 'workflows/release-management',
              label: '🏷️ Release Management',
            },
            {
              type: 'doc',
              id: 'workflows/documentation-pipeline',
              label: '📚 Documentation Pipeline',
            },
            {
              type: 'doc',
              id: 'workflows/configuration-reference',
              label: '⚙️ Configuration Reference',
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
