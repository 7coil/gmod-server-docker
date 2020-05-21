const childProcess = require('child_process');
const fs = require('fs');
const pty = require('node-pty');

childProcess.execSync('unionfs-fuse -o cow /gmod/write=RW:/gmod/instance=RO:/gmod/common=RO:/gmod/base=RO /gmod/union')

const args = [
  '-console',
  '-game', 'garrysmod',
  '-norestart',
  '+exec', 'server.cfg',
]

if (process.env.PORT) args.push('-port', process.env.PORT);
if (process.env.MAXPLAYERS) args.push('+maxplayers', process.env.MAXPLAYERS)
if (process.env.GAMEMODE) args.push('+gamemode', process.env.GAMEMODE)
if (process.env.MAP) args.push('+map', process.env.MAP)
if (process.env.WORKSHOP) args.push('+host_workshop_collection', process.env.WORKSHOP)
if (process.env.STEAM_SERVER_KEY) {
  const tokenFile = fs.readFileSync('/run/secrets/steam_server_key', { encoding: 'UTF-8' })
  const tokens = JSON.parse(tokenFile);

  args.push('+sv_setsteamaccount', tokens[process.env.STEAM_SERVER_KEY])
}

const srcds = pty.spawn('/gmod/union/srcds_run', args)

process.on('SIGTERM', () => {
  console.log('Exiting Garry\'s Mod')
  process.write('quit\r')
})

srcds.on('data', data => process.stdout.write(data));
srcds.on('exit', code => process.exit(code));
