import svelte from "rollup-plugin-svelte-hot";
import sveltePreprocess from "svelte-preprocess";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import svg from "rollup-plugin-svg";
import json from "@rollup/plugin-json";
import dsv from "@rollup/plugin-dsv";
import { terser } from "rollup-plugin-terser";

const production = true;

const preprocess = sveltePreprocess({
  scss: true,
  postcss: {
    plugins: [require("autoprefixer")]
  }
});

export default {
  input: "src/main-prod.js",
  output: {
    sourcemap: true,
    format: "iife",
    name: "app",
    file: "public/build/bundle.js"
  },
  plugins: [
    svelte({
      // we'll extract any component CSS out into
      // a separate file - better for performance
      css: css => {
        css.write("public/build/bundle.css");
      },
      preprocess
    }),

    // If you have external dependencies installed from
    // npm, you'll most likely need these plugins. In
    // some cases you'll need additional configuration -
    // consult the documentation for details:
    // https://github.com/rollup/plugins/tree/master/packages/commonjs
    resolve({
      browser: true,
      dedupe: ["svelte"]
    }),
    commonjs(),
    json(),
    dsv(),
    svg(),
    // If we're building for production (npm run build
    // instead of npm run dev), minify
    production && terser()
  ]
};
