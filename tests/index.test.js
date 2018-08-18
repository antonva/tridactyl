const path = require('path');
const expect = require('chai').expect;

const webExtensionsGeckoDriver = require('webextensions-geckodriver');
const {webdriver, firefox} = webExtensionsGeckoDriver;
const {until, By} = webdriver;

const manifestPath = path.resolve(path.join(__dirname, '../build/manifest.json'));


let geckodriver, helper;
before(async function() {
  this.timeout(10000)
  const webExtension = await webExtensionsGeckoDriver(manifestPath);
  geckodriver = webExtension.geckodriver;
  geckodriver.getWindowHandle()
  helper = {
    getById(id) {
      return geckodriver.wait(until.elementLocated(
        By.id(id)
      ), 4000);
    }
  };
});

describe('Example WebExtension', () => {

  beforeEach(async function() {
    geckodriver.get('https://emacs.org') 
  });

  it('should have a cmdline_iframe', async function() {
    let page = await geckodriver.getTitle()
    console.log(page)
    expect(1).to.equal(1)
  });

});

after(function() {
  geckodriver.quit();
});
