import React, {useState} from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import ShowcaseCard, {ShowcaseProject} from '@site/src/components/ShowcaseCard';
import styles from './showcase.module.css';

const PROJECTS: ShowcaseProject[] = [
  {
    title: 'Template-Python-UV-Project',
    description: 'A comprehensive Python project template using UV for dependency management, featuring complete CI/CD workflows, release automation, and documentation deployment.',
    website: 'https://github.com/Chisanan232/Template-Python-UV-Project',
    source: 'https://github.com/Chisanan232/Template-Python-UV-Project',
    tags: ['template', 'uv', 'ci-cd', 'documentation'],
    isTemplate: true,
  },
  {
    title: 'Abstract Backend Implementation Template',
    description: 'An opinionated starter kit that implements the Abstract Backend Execution pattern end-to-end with queue orchestration, observability, and CI/CD already wired in.',
    website: 'https://github.com/Chisanan232/abstract-backend-implementation-template',
    source: 'https://github.com/Chisanan232/abstract-backend-implementation-template',
    tags: ['template', 'abstract-backend', 'implementation', 'message-queue', 'uv'],
    isTemplate: true,
  },
  {
    title: 'slack-mcp-server',
    description: 'A robust Model Context Protocol (MCP) server implementation for Slack, built with Python and leveraging comprehensive CI/CD automation.',
    website: 'https://github.com/Chisanan232/slack-mcp-server',
    source: 'https://github.com/Chisanan232/slack-mcp-server',
    tags: ['production', 'mcp', 'slack', 'python'],
  },
  {
    title: 'clickup-mcp-server',
    description: 'MCP server implementation for ClickUp integration, demonstrating reusable workflow usage for API-based services.',
    website: 'https://github.com/Chisanan232/clickup-mcp-server',
    source: 'https://github.com/Chisanan232/clickup-mcp-server',
    tags: ['production', 'mcp', 'clickup', 'api'],
  },
  {
    title: 'abstract-backend',
    description: 'Abstract backend framework providing common patterns and utilities for Python backend services.',
    website: 'https://github.com/Chisanan232/abstract-backend',
    source: 'https://github.com/Chisanan232/abstract-backend',
    tags: ['library', 'framework', 'abstraction', 'backend', 'python'],
  },
  {
    title: 'ABE Redis',
    description: 'Redis-backed queue implementation for the Abstract Backend Execution ecosystem, featuring async job processing, telemetry hooks, and integration test fixtures.',
    website: 'https://github.com/Chisanan232/abe-redis',
    source: 'https://github.com/Chisanan232/abe-redis',
    tags: ['library', 'redis', 'message-queue', 'integration'],
  },
];

const TAGS = ['all', 'template', 'production', 'library', 'mcp', 'ci-cd'];

export default function Showcase(): JSX.Element {
  const [selectedTag, setSelectedTag] = useState('all');

  const filteredProjects = selectedTag === 'all'
    ? PROJECTS
    : PROJECTS.filter(project => project.tags.includes(selectedTag));

  return (
    <Layout
      title="Showcase"
      description="Projects using GitHub Action Reusable Workflows for Python">
      <main className={styles.showcaseMain}>
        <div className={clsx('container', styles.showcaseContainer)}>
          <div className={styles.showcaseHeader}>
            <h1 className={styles.showcaseTitle}>Showcase</h1>
            <p className={styles.showcaseDescription}>
              Discover projects that are using GitHub Action Reusable Workflows for Python in production.
              These real-world examples demonstrate how to leverage these workflows for various Python projects.
            </p>
          </div>

          <div className={styles.showcaseFilters}>
            <div className={styles.filterButtons}>
              {TAGS.map((tag) => (
                <button
                  key={tag}
                  className={clsx(
                    'button',
                    selectedTag === tag ? 'button--primary' : 'button--outline button--secondary',
                    styles.filterButton
                  )}
                  onClick={() => setSelectedTag(tag)}>
                  {tag === 'all' ? 'All' : tag}
                </button>
              ))}
            </div>
            <div className={styles.showcaseCount}>
              Showing {filteredProjects.length} {filteredProjects.length === 1 ? 'project' : 'projects'}
            </div>
          </div>

          <div className="row">
            {filteredProjects.map((project) => (
              <ShowcaseCard key={project.title} project={project} />
            ))}
          </div>

          <div className={styles.showcaseFooter}>
            <h2>Add Your Project</h2>
            <p>
              Using these reusable workflows in your project? We'd love to showcase it!
            </p>
            <div className={styles.footerButtons}>
              <a
                className="button button--primary button--lg"
                href="https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python/issues/new"
                target="_blank"
                rel="noopener noreferrer">
                Submit Your Project
              </a>
              <a
                className="button button--secondary button--lg"
                href="https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python"
                target="_blank"
                rel="noopener noreferrer">
                View on GitHub
              </a>
            </div>
          </div>
        </div>
      </main>
    </Layout>
  );
}
