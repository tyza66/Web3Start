App = {
  web3Provider: null,
  contracts: {},

  init: async function () {
    // Load pets.
    $.getJSON('../pets.json', function (data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return await App.initWeb3();
  },

  // 初始化web3
  initWeb3: async function () {
    if (typeof web3 != 'undefined') {
      App.web3Provider = web3.currentProvider
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');
    }
    web3 = new Web3(App.web3Provider); // 之后给web3设置provider
    // 创建的这个web3对象，就是我们在前端调用的web3对象，这个对象是一个全局对象，我们可以在任何地方调用它
    // 如果你在一个函数内部执行 a = 4;，且未使用 var, let 或 const 声明变量，那么在非严格模式下，这个 a 也会被创建为一个全局变量
    return App.initContract();
  },

  // 初始化智能合约
  initContract: function () {
    $.getJSON('Adoption.json', function (data) {
      var AdoptionArtifact = data;
      App.contracts.Adoption = TruffleContract(AdoptionArtifact); // TruffleContract帮我们创建一个合约实例
      App.contracts.Adoption.setProvider(App.web3Provider); // 之后给合约设置provider
      App.bindLintenEvents();
      return App.markAdopted();
    });


    return App.bindEvents();
  },

  bindEvents: function () {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  // 每次修改协议都要重新部署合约truffle migrate
  bindLintenEvents: function () {
    // 注册监听交易完成事件
    App.contracts.Adoption.deployed().then(function (instance) {
      instance.Adopted({}, function (error, event) {
        if (!error) {
          console.log(event);
          App.markAdopted();
        }
      });
    });
  },

  markAdopted: function () {
    var adoptionInstance;
    App.contracts.Adoption.deployed().then(function (instance) {
      adoptionInstance = instance;
      // call 用于调用不改变区块链状态的方法，通常用于 view 或 pure 修饰符的方法 call 方法会立即返回方法的执行结果
      return instance.getAdopters.call(); // 调用合约的getAdopters方法
    }).then(function (adopters) {
      for (i = 0; i < adopters.length; i++) {
        if (adopters[i] != "0x0000000000000000000000000000000000000000") {
          var all = $('.panel-pet');
          // eq 函数用于通过索引选择元素时，下标是从 0 开始的 但是我们有个隐藏窗口中的panel-pet给0占了
          all.eq(i + 1).find('button').text('Success').attr('disabled', true);
        }
      }
    }).catch(function (err) {
      console.log(err.message);
    });
  },

  //如果你将加密货币发送到一个不存在的地址上，交易仍然会被记录在区块链上，并且会扣除你的资金。在区块链上，一旦交易被广播并确认，它就无法撤销。如果目标地址确实不存在，这些币将无法被使用或找回

  handleAdopt: async function (event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    // 新版里面需要用户授权
    try {
      // 请求用户授权
      await App.web3Provider.enable();
    } catch (error) {
      // 用户不授权时
      console.error("User denied account access")
    }

    web3.eth.getAccounts(function (error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0]; // 将拿到的第一个账号赋值给account

      // 每次调用 deployed() 方法时，都会返回已经部署的合约实例。这意味着你获取到的合约实例是相同的，并且引用的是同一个智能合约部署地址
      App.contracts.Adoption.deployed().then(function (instance) {
        // 方法名调用用于调用会改变区块链状态的方法，例如更新合约中的数据。这些方法会消耗 gas 并产生交易 这种调用方式需要将事务提交到区块链，因此需要指定 from 地址等参数
        return instance.adopt(petId, { from: account }); // account是调用者的地址
      }).then(function (result) {
        console.log(result);
        return App.markAdopted(); // 更新当前的领养状态 但是交易是需要处理时间的 所以这里不一定能够立即更新 我就不改了 这是异步的问题
      }).catch(function (err) {
        console.log(err.message);
      });
    });
  }

};

$(function () {
  $(window).load(function () {
    App.init();
  });
});

// lite-server的每个窗口默认动态同步刷新，但是如果你想要关闭这个功能，可以在bs-config.json文件中设置ghostMode为false