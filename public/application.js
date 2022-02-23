(() => {
  const application = Stimulus.Application.start()

  application.register("app", class extends Stimulus.Controller {
    static targets = ['registerForm', 'loginForm']
    register(eve){
      eve.preventDefault();
      // MUST move repeted code to a helper
      let formInputs = eve.target.querySelectorAll("input");
      let data = {};
      for( var i=0; i < formInputs.length; i++ ){
      	if(formInputs[i].name != ""){
          data[formInputs[i].name] = formInputs[i].value
      	}
      }
      fetch('/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data),
      })
      .then((response) => {
      	return response.json()
      })
      .then((data) => {
        sessionStorage.setItem("token", data.token);
        document.getElementById('register').classList.add('hidden');
        document.getElementById('login').classList.add('hidden');
        document.getElementById('get-current').click();
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
    login(eve){
      eve.preventDefault();
       // MUST move repeted code to a helper
      let formInputs = eve.target.querySelectorAll("input");
      let data = {};
      for( var i=0; i < formInputs.length; i++ ){
      	if(formInputs[i].name != ""){
          data[formInputs[i].name] = formInputs[i].value
      	}
      }
      fetch('/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data),
      })
      .then((response) => {
      	return response.json()
      })
      .then((data) => {
        sessionStorage.setItem("token", data.token);
        document.getElementById('register').classList.add('hidden')
        document.getElementById('login').classList.add('hidden')
        document.getElementById('get-current').click()
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
    showRegister(eve){
      eve.preventDefault();
      document.getElementById('login').classList.add('hidden')
      document.getElementById('register').classList.remove('hidden')
    }
    showLogin(eve){
      eve.preventDefault();
      document.getElementById('register').classList.add('hidden')
      document.getElementById('login').classList.remove('hidden')
    }
    getCurrent(eve){
      eve.preventDefault();
      fetch('/v1/current', {
        method: 'GET',
        headers: {
          'Authorization': 'Bearer ' + sessionStorage.getItem('token')
        }
      })
      .then((response) => {
        return response.json()
      })
      .then((data) => {
        document.getElementById('current').value = data.attributes.app
        document.getElementById('current-span').innerText = data.attributes.app
        document.getElementById('app').classList.remove('hidden')
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
    getNext(eve){
      eve.preventDefault();
      fetch('/v1/next', {
        method: 'GET',
        headers: {
          'Authorization': 'Bearer ' + sessionStorage.getItem('token')
        }
      })
      .then((response) => {
        return response.json()
      })
      .then((data) => {
        document.getElementById('current').value = data.attributes.app
        document.getElementById('current-span').innerText = data.attributes.app
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
    setCurrent(eve){
      eve.preventDefault();
      fetch('/v1/next', {
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer ' + sessionStorage.getItem('token'),
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({'current': document.getElementById('current').value}),
      })
      .then((response) => {
        return response.json()
      })
      .then((data) => {
        document.getElementById('current').value = data.attributes.app
        document.getElementById('current-span').innerText = data.attributes.app
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
  })
})()