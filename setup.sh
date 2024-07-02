echo '== Setting up Dpkg options ==' &&
  export DEBIAN_FRONTEND=noninteractive &&
  echo -e 'Dpkg::Options {\n  "--force-confnew";\n}' > ~/../usr/etc/apt/apt.conf.d/local &&
  echo '== Removing invalid repositories ==' &&
  pkg remove -y game-repo &&
  pkg remove -y science-repo &&
  echo '== Updating repositories and upgrading packages ==' &&
  pkg update -y &&
  pkg upgr -y &&
  echo '== Installing python, openssl and nodejs ==' &&
  pkg i -y python openssl-1.1 nodejs-lts &&
  echo '== Removing added Dpkg options ==' &&
  rm ~/../usr/etc/apt/apt.conf.d/local &&
  echo '== Installing homebridge and homebridge-config-ui ==' &&
  npm install -g --unsafe-perm homebridge &&
  npm install -g --unsafe-perm homebridge-config-ui-x

  echo '== Fixing the error ==' &&
  sed 's/argv\.push(\x27-I\x27, addonGypi)/argv\.push(\x27-I\x27, addonGypi);argv\.push(\x27-Dandroid_ndk_path=""\x27)/g' /data/termux/node_modules/node-gyp/lib/configure.js

  echo '== Installing homebridge and homebridge-config-ui again ==' &&
  npm install -g --unsafe-perm homebridge &&
  npm install -g --unsafe-perm homebridge-config-ui-x &&
  echo '== Creating default config ==' &&
  mkdir -p ~/.homebridge &&
  echo -e '{\n	"bridge": {\n		"name": "Homebridge",\n		"advertiser": "bonjour-hap"\n	},\n	"accessories": [],\n	"platforms": [\n		{\n			"name": "Config",\n			"port": 8581,\n			"platform": "config",\n			"log": {\n				"method": "file",\n				"path": "/data/data/com.termux/files/home/.homebridge/homebridge.log"\n			}\n		}\n	]\n}\n' > ~/.homebridge/config.json &&
  echo '== Adding homebridge commands ==' &&
  echo 'exec npx homebridge "$@" 2>&1 | tee ~/.homebridge/homebridge.log' > ~/../usr/bin/hb &&
  chmod +x ~/../usr/bin/hb &&
  echo -e '== Installation successful ==\nExecute hb command to start'
