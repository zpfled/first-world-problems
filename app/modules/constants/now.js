module.exports = Math.ceil(Date.now() / 86400000);

// TESTED

if(process.argv[1] === __filename) {
	console.log(2592000000 / 86400002);
	console.log(Math.ceil(2592000000 / 86400002) == 30);
}