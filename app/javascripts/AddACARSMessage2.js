var program = require('commander');

program.version("0.1")
       .option('-t, --timestamp <n>', 'Timestamp (seconds since unix epoch', parseInt)
       .option('-c, --channel <n>', 'Channel', parseInt)
       .option('-i, --idstr [id]', 'ID String')
       .option('-e, --err <n>', 'Err', parseInt)
       .option('-l, --level <n>', 'Level', parseInt)
       .option('-m, --mode [mode]', 'Mode')
       .option('-a, --aircraftregistration [aircraftregiration]', 'Aircraft Registration')
       .option('-k, --ack [ack]', 'Ack')
       .option('-b, --label [label]', 'Label')
       .option('-d, --bid [bid]', 'Bid')
       .option('-n, --number [number]', 'Number')
       .option('-f, --flightid [flightid]', 'Flight ID')
       .option('-g, --message [message]', 'Message')
       .parse(process.argv);

var ACARSGroundStation = artifacts.require("ACARSGroundStation");

module.exports = function(callback) {
  
  var ts = Math.round((new Date()).getTime() / 1000);

  ACARSGroundStation.deployed().then(function(instance) {
    instance.PublishACARSMessage(program.timestamp, 
                                 program.channel, 
                                 program.idstr, 
                                 program.err,
                                 program.level,
                                 program.mode,
                                 program.aircraftregistration,
                                 program.ack,
                                 program.label,
                                 program.bid,
                                 program.number,
                                 program.flightid,
                                 program.message);
  });
  callback();
}

