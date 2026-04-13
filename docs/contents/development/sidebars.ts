import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Sidebar for the Dev section
 */
const sidebars: SidebarsConfig = {
  dev: [
    {
      type: 'doc',
      id: 'development',
      label: '🚀 Development Overview',
    },
    {
      type: 'category',
      label: '⚙️ CI/CD System',
      collapsed: false,
      items: [
        {
          type: 'doc',
          id: 'ci-cd/index',
          label: '🎯 CI/CD Overview',
        },
        {
          type: 'doc',
          id: 'ci-cd/continuous-integration',
          label: '🧪 Test Workflows',
        },
        {
          type: 'doc',
          id: 'ci-cd/release-system',
          label: '🚀 Release System',
        },
        {
          type: 'doc',
          id: 'ci-cd/documentation-deployment',
          label: '📚 Documentation Deployment',
        },
        {
          type: 'doc',
          id: 'ci-cd/developer-guide',
          label: '👨‍💻 Developer Guide',
        },
      ],
    },
  ],
};

export default sidebars;
