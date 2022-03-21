# Contributing to [OCram85.com](https://ocram85.com) blog

## Usage

To use the sources for local development you need to install the dependencies first:

```bash
npm install
```

### How to add new posts

To simplify the workflow for adding new posts you can run the npm script `new:post` with a valid path:

```bash
npm run new:post -- posts/my-new-post/index.md
```

This creates a new post file an populates the values from default [template file](./archetypes/default.md)

## npm scripts

### `build`

Use `npm run build` to build the html files for production.

### `check`

Use `npm run check` to get the current version for the embedded hugo version.

### `clean`

Use `npm run clean` to clean the _public_ content.

### `lint:markdown`

Use `npm run lint:markdown` to run the markdown linter for identifying markdown issues.

### `start`

Use `npm run start` as alias for `npm run server`.

### `server`

Use `npm run server` to start the development server which renders also draft posts. You can access the development server via `http://localhost:1313`

### `test`

Use `npm run test` all nested test tasks. For now this points to _lint:markdown_.

### `postinstall`

`npm run postinstall` is used by `npm install` to get the latest embedded hugo binary version.

### `new:post`

Use `npm run new:post` to create a new blog post based on the archetype template.
