import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import { useLatestVersion, useDocById } from '@docusaurus/plugin-content-docs/client';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  
  // Get all versions from the docs plugin
  const allDocs = useLatestVersion('docs');
  const docsBasePath = '/docs';
  
  // Find the latest stable version (not "next")
  const stableVersion = allDocs?.versions?.find(version => version.name !== 'current' && version.name !== 'next');
  
  // Calculate the path to the stable documentation with fallbacks
  const stableDocsPath = stableVersion?.path || 
    (stableVersion?.name ? `${docsBasePath}/${stableVersion.name}/introduction` : `${docsBasePath}/next/introduction`);
  
  return (
    <header className={styles.heroBanner}>
      <div className={styles.heroContainer}>
        <div className={styles.heroContent}>
          <Heading as="h1" className={styles.heroTitle}>
            GitHub Action
            <br />
            Reusable Workflows
          </Heading>
          <p className={styles.heroSubtitle}>
            Production-ready CI/CD workflows for Python projects, featuring automated testing, 
            deployment, and release management with comprehensive documentation.
          </p>
          <div className={styles.heroButtons}>
            <Link
              className={clsx('button button--primary button--lg', styles.heroButton)}
              to={stableDocsPath}>
              Get Started →
            </Link>
            <Link
              className={clsx('button button--secondary button--lg', styles.heroButton)}
              to="/showcase">
              View Showcase
            </Link>
          </div>
        </div>
        <div className={styles.heroVisual}>
          <div className={styles.visualContainer}>
            {/* Background layer - GitHub Actions */}
            <div className={styles.backgroundLayer}>
              <img 
                src={require('@site/static/img/github_action_with_text_logo.png').default}
                alt="GitHub Actions" 
                className={styles.githubLogo}
              />
            </div>
            {/* Foreground layer - Python (translucent) */}
            <div className={styles.foregroundLayer}>
              <img 
                src={require('@site/static/img/python_logo_icon.png').default}
                alt="Python" 
                className={styles.pythonLogo}
              />
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`Hello from ${siteConfig.title}`}
      description="Description will go into a meta tag in <head />">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
