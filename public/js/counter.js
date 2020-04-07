(() => {
  const application = Stimulus.Application.start()

  application.register("counter", class extends Stimulus.Controller {
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
        document.helpers.hideOverlay(null);
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
        document.helpers.hideOverlay(null);
        document.getElementById('get-current').click()
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
    showRegister(eve){
      eve.preventDefault();
      document.helpers.showOverlay('register');
    }
    showLogin(eve){
      eve.preventDefault();
      document.helpers.showOverlay('login');
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
        return document.helpers.handleResponse(response)
      })
      .then((data) => {
        document.helpers.setCurrent(data)
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
        let zeroPadded = document.helpers.zeroPad(data.attributes.counter)
        document.getElementById('current').innerText = zeroPadded
        document.getElementById('current-input').value = data.attributes.counter
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
        body: JSON.stringify({'current': document.getElementById('current-input').value}),
      })
      .then((response) => {
        return response.json()
      })
      .then((data) => {
        let zeroPadded = document.helpers.zeroPad(data.attributes.counter)
        document.getElementById('current').innerText = zeroPadded
        document.getElementById('current-input').value = data.attributes.counter
      })
      .catch((error) => {
        window.alert('An error ocurred')
      });
    }
  })
})()