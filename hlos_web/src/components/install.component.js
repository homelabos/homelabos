/*

  AS OF NOW UNUSED - MAYBE USE FOR 100% UI INSTALL IF HLOS
  BECOMES A DOCKER PULL RELEASE.

*/
import React, { Component } from "react";
import AnsibleApiDataService from "../services/ansible-api.service";

export default class Install extends Component {
  constructor(props) {
    super(props);
    // debug fields
    this.onAPIResponse = this.onAPIResponse.bind(this);
    this.onAPIResponseErrors = this.onAPIResponseErrors.bind(this);

    // Step 1
    this.onChangeDefaultUser = this.onChangeDefaultUser.bind(this);
    this.onChangeDefaultPass = this.onChangeDefaultPass.bind(this);
    this.onChangeHostIp      = this.onChangeHostIp.bind(this);
    this.onChangeDomain      = this.onChangeDomain.bind(this);
    this.onChangeAdminEmail  = this.onChangeAdminEmail.bind(this);
    this.onChangeTimezone    = this.onChangeTimezone.bind(this);

    this.onChangeSSHUser = this.onChangeSSHUser.bind(this);
    this.onChangeSSHPass = this.onChangeSSHPass.bind(this);
    this.checkApiIsUp = this.checkApiIsUp.bind(this);
    this.configServer = this.configServer.bind(this);
    this.deployServer = this.deployServer.bind(this);
    this.decryptVault = this.decryptVault.bind(this);
    this.encryptVault = this.encryptVault.bind(this);

    this.state = {
      step: 1,

      // Step 1
      defaultuser: props.env.defaultuser,
      defaultpass: props.env.defaultpass,
      hostip: props.env.hostip,
      domain: props.env.domain,
      admin_email: props.env.admin_email,
      timezone: props.env.timezone,

      sshuser: "",
      sshpass: "",
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

  onChangeSSHUser(e) {
    this.setState({
      sshuser: e.target.value
    });
  }

  onChangeSSHPass(e) {
    this.setState({
      sshpass: e.target.value
    });
  }

  onAPIResponse(e) {
    this.setState({
      onapireaponse: e.target.value
    });
  }

  onAPIResponseErrors(e) {
    this.setState({
      onapireaponseerrors: e.target.value
    });
  }

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

  configServer() {
    AnsibleApiDataService.config(
      this.state.defaultuser,
      this.state.defaultpass,
      this.state.hostip,
      this.state.domain,
      this.state.admin_email,
      this.state.timezone)
      .then(response => {
        this.setState({
          apiresponse: JSON.stringify(response.data.detail),
          apiresponseerrors: response.data.error,
        });
        console.log(response.data);
      })
      .catch(e => {
        console.log(e);
      });
  }

  deployServer() {

  }

  decryptVault() {
    AnsibleApiDataService.cryptVault("decrypt")
      .then(response => {
        this.setState({
          apiresponse: JSON.stringify(response.data.detail),
          apiresponseerrors: response.data.error,
        });
        console.log(response.data);
      })
      .catch(e => {
        console.log(e);
      });
  }

  encryptVault() {
    AnsibleApiDataService.cryptVault("encrypt")
      .then(response => {
        this.setState({
          apiresponse: JSON.stringify(response.data.detail),
          apiresponseerrors: response.data.error,
        });
        console.log(response.data);
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
          <label htmlFor="apiresponse">API Response</label><br></br>
          <textarea
            //required
            value={this.state.apiresponse}
            onChange={this.onAPIResponse}
            name="apiresponse"
            style={{ width: 600+'px', height: 300+'px' }}
          />
        </div>
        <div>
          <label htmlFor="apiresponseerrors">API Response Errors</label><br></br>
          <textarea
            //required
            value={this.state.apiresponseerrors}
            onChange={this.onAPIResponseErrors}
            name="apiresponseerors"
            style={{ width: 600+'px', height: 300+'px' }}
          />
        </div>
      </>
    );
  }

  render() {
    return (
      <div className="submit-form">
        <div>
          The first step is entering the basic configuration parameters and installing the software needed on the server to support the containerised services.
          Additionally the installation will setup Traefik to manage routing browser access to your services.
          <br></br>
          Once the installation is complete, proceed to configuring other HomelabOS defaults and services.
          <br></br>
          When installation reports back everything went well, you should visit <a href={ `http://traefik.${this.state.domain}:8181` }>your new Traefik container</a>
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
          Check API is up
        </button>
        <button
          disabled={!this.state.api_check_ok}
          onClick={this.configServer}
          className="btn btn-success">
          Create default config
        </button>
        {this.debugAreas()}
      </div>
    );
  }
}
