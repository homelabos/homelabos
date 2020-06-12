import React, { Component } from "react";
import AnsibleApiDataService from "../services/ansible-api.service";

export default class Service extends Component {
  constructor(props) {
    super(props);
    this.onChangeHostIp      = this.onChangeHostIp.bind(this);

    this.onChangeService = this.onChangeService.bind(this);
    this.onChangeProperty = this.onChangeProperty.bind(this);
    this.onChangeValue = this.onChangeValue.bind(this);
    this.onAPIResponse = this.onAPIResponse.bind(this);
    this.onAPIResponseErrors = this.onAPIResponseErrors.bind(this);

    this.checkApiIsUp = this.checkApiIsUp.bind(this);

    this.deployService = this.deployService.bind(this);
    this.setServiceSetting = this.setServiceSetting.bind(this);

    this.state = {
      hostip: this.props.env.hostip,

      service: "",
      property: "",
      value: "",
      apiresponse: "",
      apiresponseerrors: "",
    };
  }

  onChangeHostIp(e) {
    this.setState({
      hostip: e.target.value
    });
  }

  onChangeService(e) {
    this.setState({
      service: e.target.value
    });
  }

  onChangeProperty(e) {
    this.setState({
      property: e.target.value
    });
  }

  onChangeValue(e) {
    this.setState({
      value: e.target.value
    });
  }

  onAPIResponse(e) {
    this.setState({
      apireaponse: e.target.value
    });
  }

  onAPIResponseErrors(e) {
    this.setState({
      apiresponseerrors: e.target.value
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

  checkApiIsUp() {
    AnsibleApiDataService.setBaseURL(this.state.hostip);
    AnsibleApiDataService.getApi()
      .then(response => {
        this.setState({
          apiresponse: response.data.message,
        });
        console.log(response.data);
      })
      .catch(e => {
        console.log(e);
      });
  }

  deployService(service) {
    AnsibleApiDataService.deployService()
      .then(response => {
        this.setState({
          apiresponse: this.formatResponse(response.data.detail),
          apiresponseerrors: JSON.stringify(response.data.error),
        });
        console.log(response.data);
      })
      .catch(e => {
        console.log(e);
      });
  }

  setServiceSetting(service_property, value) {
    AnsibleApiDataService.setServiceProperty(service_property, value)
      .then(response => {
        this.setState({
          apiresponse: this.formatResponse(response.data.detail),
          apiresponseerrors: JSON.stringify(response.data.error),
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
          <h1>Welcome to HomelabOS Service Selection.</h1>
          Here you can activate services, an/or set properties on the services.  If you just want to enable
          a service, like 'portainer', simply write 'portainer' n the service field, and click the Enable
          button below.  Disabling is the same, just click the Disable button instead.
          <br></br>
          When you are ready, click the Deploy button to activate your choices.
          <br></br>
          The very first time yoy press the deploy button, you get Traefik started as well.
          <br></br>
          Please note this is a very rough initial web UI, just functional enough to allow you to configure,
          and get services running.  Don't expect a very polished experience at this point in time.
          <br></br>
          <br></br>
        </div>
        {this.inputField("Server IP", "hostip",
            this.state.hostip, this.onChangeHostIp)}
        {this.inputField("Service", "service",
            this.state.service, this.onChangeService)}
        {this.inputField("Property", "property",
            this.state.property, this.onChangeProperty)}
        {this.inputField("Value", "value",
            this.state.value, this.onChangeValue)}
        <button onClick={this.checkApiIsUp} className="btn btn-success">
          Check API is up
        </button>
        <button
          onClick={ () => this.setServiceSetting(this.state.service+".enable", "true")}
          className="btn btn-success"
        >
          Enable Service
        </button>
        <button
          onClick={ () => this.setServiceSetting(this.state.service+".enable", "false")}
          className="btn btn-success"
        >
          Disable Service
        </button>
        <button
          onClick={ () => this.setServiceSetting(this.state.service+"."+this.state.property, this.state.value)}
          className="btn btn-success"
        >
          Set Service Property
        </button>
        <button
          onClick={ () => this.deployService(this.state.service)}
          className="btn btn-success"
        >
          Deploy the Service
        </button>
        {this.debugAreas()}
      </div>
    );
  }
}
