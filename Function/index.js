exports.stopInstances = (event, context) => {
    const str = event.data
    ? Buffer.from(event.data, 'base64').toString()
    : 'Empty';
    var json = JSON.parse(str);
    let instancesList = json.instances;
    let zoneVar = json.zone;
    var instanceSplit = instancesList.split(',');
    instanceSplit.forEach(instance => {
        var Compute = require('@google-cloud/compute');
        var compute = Compute();
        var zone = compute.zone(zoneVar);
        var vm = zone.vm(instance);
        vm.stop(function (err, operation, apiResponse) { console.log('Stopped '+instance); });
    });
    res.status(200).send('Success stopped instances');
};
