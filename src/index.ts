/**
 * Copyright © 2019 kevinpollet <pollet.kevin@gmail.com>`
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE.md file.
 */

import { getInput } from "@actions/core";

const ghToken = getInput("GITHUB_TOKEN");

console.log(`Hello, ${ghToken}!`);
