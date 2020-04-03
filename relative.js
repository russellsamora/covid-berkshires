const fs = require("fs");
const replace = require("replace-in-file");

const options = {
  files: "__sapper__/export/index.html",
  from: ["<base href=/ >", /"\/client/g],
  to: ['<base href="" >', '"client']
};

replace(options, (err, result) => {
  if (err) console.log(err);
  process.exit();
});
