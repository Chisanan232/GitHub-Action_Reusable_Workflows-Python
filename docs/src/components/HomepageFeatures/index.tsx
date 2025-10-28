import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  image: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Easy to Use',
    image: require('@site/static/img/easy_to_use.png').default,
    description: (
      <>
        GitHub Action Reusable Workflows are designed to be easily integrated into your projects.
        Get your CI/CD pipeline up and running quickly with minimal configuration.
      </>
    ),
  },
  {
    title: 'Built for Python',
    image: require('@site/static/img/python_base.png').default,
    description: (
      <>
        Specifically designed for Python projects with support for pip, Poetry, and various testing frameworks.
        Leverage battle-tested workflows for testing, deployment, and release automation.
      </>
    ),
  },
];

function Feature({title, image, description}: FeatureItem) {
  return (
    <div className={clsx('col col--6')}>
      <div className="text--center">
        <img className={styles.featureSvg} src={image} alt={title} />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
