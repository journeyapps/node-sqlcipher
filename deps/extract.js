const fs = require('fs');
const tar = require('tar');

const [_node, _script, src, dest] = process.argv;

const { size } = fs.statSync(src);
if (size < 1000) {
    console.error('Not a valid .tar.gz file:', src);
    console.error('Check if git-lfs is configured correctly.');
    process.exit(1);
}
fs.mkdirSync(dest, { recursive: true });
tar.x({ C: dest, file: src, sync: true });
