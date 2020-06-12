import React, { Component } from "react";
import AnsibleApiDataService from "../services/ansible-api.service";
//import LocalStorage from "./localStorage.component";

export default class Config extends Component {
  constructor(props) {
    super(props);
    // debug fields
    //this.onAPIResponse = this.onAPIResponse.bind(this);
    //this.onAPIResponseErrors = this.onAPIResponseErrors.bind(this);

    // Step 1
    this.onChangeDefaultUser = this.onChangeDefaultUser.bind(this);
    this.onChangeDefaultPass = this.onChangeDefaultPass.bind(this);
    this.onChangeHostIp      = this.onChangeHostIp.bind(this);
    this.onChangeDomain      = this.onChangeDomain.bind(this);
    this.onChangeAdminEmail  = this.onChangeAdminEmail.bind(this);
    this.onChangeTimezone    = this.onChangeTimezone.bind(this);

    this.checkApiIsUp = this.checkApiIsUp.bind(this);
    this.configServer = this.configServer.bind(this);
    this.encryptVault = this.encryptVault.bind(this);

    this.state = {
      defaultuser: props.env.defaultuser,
      defaultpass: props.env.defaultpass,
      hostip: props.env.hostip,
      domain: props.env.domain,
      admin_email: props.env.admin_email,
      timezone: props.env.timezone,

      published: false,
      onapiresponse: "",
      onapireaponseerrors: "",

      // Signals for enable/disable buttons
      api_check_ok: false,
    };
  }

  onChangeDefaultUser(e) {
    this.setState({
      defaultuser: e.target.value
    });
  }

  onChangeDefaultPass(e) {
    this.setState({
      defaultpass: e.target.value
    });
  }

  onChangeHostIp(e) {
    this.setState({
      hostip: e.target.value
    });
  }

  onChangeDomain(e) {
    this.setState({
      domain: e.target.value
    });
  }

  onChangeAdminEmail(e) {
    this.setState({
      admin_email: e.target.value
    });
  }

  onChangeTimezone  (e) {
    this.setState({
      timezone: e.target.value
    });
  }

/*
  onAPIResponse(e) {
    this.setState({
      onapiresponse: e.target.value
    });
  }

  onAPIResponseErrors(e) {
    this.setState({
      onapireaponseerrors: e.target.value
    });
  }
 */

  checkApiIsUp() {
    AnsibleApiDataService.setBaseURL(this.state.hostip);
    AnsibleApiDataService.getApi()
      .then(response => {
        let ok = false;
        if(response.data.message === "Hello, I am Ansible Api") {
          ok = true;
        }
        this.setState({
          apiresponse: response.data.message,
          api_check_ok: ok,
        });
        console.log(response.data);
      })
      .catch(e => {
        console.log(e);
      });
  }

  formatResponse(response_detail) {
    let fmt_text = "";
    Object.keys(response_detail).forEach(host => {
      response_detail[host].forEach(line => {
        fmt_text += line.task_name + "\n";
      });
    });
    return fmt_text;
  }

  configServer() {
    // Two calls are made here:
    // 1. Configure - create the default config files based on the input given here.
    // 2. Deploy    - install the remaining system dependencies and Traefik.
    AnsibleApiDataService.createConfiguration(
      this.state.defaultuser,
      this.state.defaultpass,
      this.state.hostip,
      this.state.domain,
      this.state.admin_email,
      this.state.timezone)
      .then(response => {
        console.log(response.data);
        this.setState({
          apiresponse: this.formatResponse(response.data.detail),
          apiresponseerrors: JSON.stringify(response.data.error),
        });
      })
      .catch(e => {
        console.log(e);
      });

    this.encryptVault();

    AnsibleApiDataService.deploySystem()
      .then(response => {
        console.log(response.data);
        this.setState({
          apiresponse: this.formatResponse(response.data.detail),
          apiresponseerrors: JSON.stringify(response.data.error),
        });
      })
      .catch(e => {
        console.log(e);
      });
  }

  encryptVault() {
    AnsibleApiDataService.cryptVault("encrypt")
      .then(response => {
        console.log(response.data);
        this.setState({
          apiresponse: this.formatResponse(response.data.detail),
          apiresponseerrors: JSON.stringify(response.data.error),
        });
      })
      .catch(e => {
        console.log(e);
      });
  }

  inputField(label, id, value, on_change, is_password=false) {
    return (
      <div className="form-group">
        <label htmlFor={label}>{label}</label>
        {is_password ? (
        <input
          type="password"
          className="form-control"
          id={id}
          required
          value={value}
          onChange={on_change}
          name={label}
        />) : (
        <input
          type="text"
          className="form-control"
          id={id}
          required
          value={value}
          onChange={on_change}
          name={label}
        />
        )}
      </div>
    );
  }

  debugAreas() {
    return (
      <>
        <div>
          <br />
          <label htmlFor="apiresponse">API Response</label><br></br>
          <textarea
            //required
            value={this.state.apiresponse}
//            onChange={this.onAPIResponse}
            name="apiresponse"
            style={{ width: 600+'px', height: 300+'px' }}
          />
        </div>
        <div>
          <label htmlFor="apiresponseerrors">API Response Errors</label><br></br>
          <textarea
            //required
            value={this.state.apiresponseerrors}
//            onChange={this.onAPIResponseErrors}
            name="apiresponseerors"
            style={{ width: 600+'px', height: 100+'px' }}
          />
        </div>
      </>
    );
  }

  /**********************************************************/
  /* This part for saving to local browser storage          */
  hydrateStateWithLocalStorage() {
    // for all items in state
    for (let key in this.state) {
      // if the key exists in localStorage
      if (localStorage.hasOwnProperty(key)) {
        // get the key's value from localStorage
        let value = localStorage.getItem(key);

        // parse the localStorage string and setState
        try {
          value = JSON.parse(value);
          this.setState({ [key]: value });
        } catch (e) {
          // handle empty string
          this.setState({ [key]: value });
        }
      }
    }
  }

  saveStateToLocalStorage() {
    // for every item in React state
    for (let key in this.state) {
      // save to localStorage
      localStorage.setItem(key, JSON.stringify(this.state[key]));
    }
  }

  componentDidMount() {
    this.hydrateStateWithLocalStorage();

    // add event listener to save state to localStorage
    // when user leaves/refreshes the page
    window.addEventListener(
      "beforeunload",
      this.saveStateToLocalStorage.bind(this)
    );
  }

  componentWillUnmount() {
    window.removeEventListener(
      "beforeunload",
      this.saveStateToLocalStorage.bind(this)
    );

    // saves if component has a chance to unmount
    this.saveStateToLocalStorage();
  }
 /*********************************************/

  render() {
    return (
      <div className="submit-form">
{/*        <LocalStorage state={this.state} /> */}
        <div>
          <h1>Welcome to HomelabOS Configuration.</h1>
          Before you can deply services on your new system, we need a few bits and pieces of information.
          To get here you already succeeded in setting up a specific user account on your server,
          from which we will run the service.  You have a set of SSH keys and an Ansible vault password in the
          user account you used to setup the HomelabOS system.  Please back up these files, as it is the
          only way to login to the HomelabOS user account.
          <br></br>
          To complete the installation you need to provide some information below. When ready press the buttons below.
          <br></br>
          After you press the "Configure HomelabOS" button you will see the message "Start HomelabOS Traefik" in the
          API reponse window.  This should be the signal for you to continue to the Service screen.
          <br></br>
          Note: If you don't see this message, please press the Configure button again :-)
          <br></br>
          When installation reports back everything went well, you should visit <a href={ `http://traefik.${this.state.domain}:8181` }>your new Traefik container</a>
          <br></br>
          Please note this is a very rough initial web UI, just functional enough to allow you to configure, and get services running.  Don't expect a very polished experience at this point in time.
          <br></br>
          <br></br>
        </div>
        {this.inputField("Server IP", "hostip",
            this.state.hostip, this.onChangeHostIp)}
        {this.inputField("Server Domain", "domain",
            this.state.domain, this.onChangeDomain)}
        {this.inputField("Server Time zone", "timezone",
            this.state.timezone, this.onChangeTimezone)}
        {this.inputField("Default Username", "defaultuser",
            this.state.defaultuser, this.onChangeDefaultUser)}
        {this.inputField("Default User Password", "defaultpass",
            this.state.defaultpass, this.onChangeDefaultPass, true)}
        {this.inputField("Admin Email", "adminemail",
            this.state.admin_email, this.onChangeAdminEmail)}
        <button onClick={this.checkApiIsUp} className="btn btn-success">
          Check connection is okay
        </button>
        <button
          disabled={!this.state.api_check_ok}
          onClick={this.configServer}
          className="btn btn-success">
          Configure HomelabOS
        </button>
        {this.debugAreas()}
      </div>
    );
  }
}
