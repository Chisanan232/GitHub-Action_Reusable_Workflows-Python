import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import styles from './styles.module.css';

export interface ShowcaseProject {
  title: string;
  description: string;
  website: string;
  source: string;
  tags: string[];
  isTemplate?: boolean;
}

export default function ShowcaseCard({project}: {project: ShowcaseProject}): JSX.Element {
  return (
    <div className={clsx('col col--4', styles.showcaseCard)}>
      <div className={clsx('card', styles.card)}>
        <div className="card__body">
          <div className={styles.cardHeader}>
            <h3 className={styles.cardTitle}>
              <Link to={project.website} className={styles.cardTitleLink}>
                {project.title}
              </Link>
            </h3>
            {project.isTemplate && (
              <span className={styles.templateBadge}>Template</span>
            )}
          </div>
          <p className={styles.cardDescription}>{project.description}</p>
          <div className={styles.cardTags}>
            {project.tags.map((tag) => (
              <span key={tag} className={styles.tag}>
                {tag}
              </span>
            ))}
          </div>
        </div>
        <div className="card__footer">
          <div className={styles.cardButtons}>
            <Link
              className="button button--primary button--sm"
              to={project.source}>
              View Repository
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
