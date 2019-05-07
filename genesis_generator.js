let inquirer = require('inquirer');
let jsonfile = require('jsonfile');
let program = require('commander');

program.version('0.1.0')
    .option('--from-genesis [fromGenesis]', 'from local genesis')
    .parse(process.argv);

var jsonContent = jsonfile.readFileSync(program.fromGenesis);

inquirer.prompt([
    {
        type: 'gas_price',
        name: 'gas_price',
        message: 'gas price',
        default: 2000000
    }
]).then(answers => {
    jsonContent.params.gas_price = answers['gas_price'];
    console.log(jsonContent.params);
    jsonfile.writeFileSync(program.fromGenesis, jsonContent);
});
