const fs = require('fs');
const tar = require('tar');

const [_node, _script, src, dest] = process.argv;

fs.mkdirSync(dest, { recursive: true });
tar.x({ C: dest, file: src, sync: true });
