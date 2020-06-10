import React, { Component } from "react";
import AnsibleApiDataService from "../services/ansible-api.service";

export default class Maintenance extends Component {
  constructor(props) {
    super(props);

    this.onChangeHostIp      = this.onChangeHostIp.bind(this);
    // debug fields
    this.onAPIResponse = this.onAPIResponse.bind(this);
    this.onAPIResponseErrors = this.onAPIResponseErrors.bind(this);

    this.checkApiIsUp = this.checkApiIsUp.bind(this);
    this.decryptVault = this.decryptVault.bind(this);
    this.encryptVault = this.encryptVault.bind(this);


    this.state = {
      hostip: this.props.env.hostip,
      onapiresponse: "",
      onapireaponseerrors: "",
      api_check_ok: false,
    };
  }

  onChangeHostIp(e) {
    this.setState({
      hostip: e.target.value
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
              <>
              <div>
                {this.inputField("Server IP", "hostip",
                    this.state.hostip, this.onChangeHostIp)}
              </div>
              <button
                onClick={this.checkApiIsUp}
                className="btn btn-success"
              >
                Check API is up
              </button>
              <button
                disabled={!this.state.api_check_ok}
                onClick={this.decryptVault}
                className="btn btn-success"
              >
                Vault decrypt
              </button>
              <button
                disabled={!this.state.api_check_ok}
                onClick={this.encryptVault}
                className="btn btn-success"
              >
                Vault encrypt
              </button>
            </>
          {this.debugAreas()}
        </div>
      </div>
    );
  }
}
