// Code written knowing very well that I am not a ReactJS expert by any means.
// Feel free to do it better, there is noting which cannot be changed outside of the
// calls to the ansible API service layer.

/* Setting up a fresh project for this:
npx create-react-app react-crud
npm install bootstrap
npm install react-router-dom
npm install axios
npm install sha256
npm install local-storage

To get around CORS in the web browser (development mode):
  google-chrome --disable-web-security --user-data-dir=<<somedir>>
*/

import React, { Component } from "react";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";

// Maybe an idea to make the whole setup via the web UI?
//  Requires docker on the server initially.
//  Then can we build the ansible-api and continue from there?
//  I can SSH to a host: https://www.npmjs.com/package/node-ssh
//  Which means I can run a shell script after dumping it on the host.
//  Which means I can run the Web UI from any docker-enabled client initially
//    and bootstrap which everhost I desire.
//  Which means it is possible to do a fully web UI-based installation.
import Config from "./components/config.component";
import Service from "./components/service.component";
import Maintenance from "./components/maintenance.component";


class App extends Component {
  env = {};

  constructor() {
    super();
    // Pull in variables from the environment
    // NOTE: This only works dynamically in development mode.  IF these variables are to be
    //       used in production mode, they are all BAKED INTO the app.
    //       I.e. forget changing them in a docker.compose file for instance.
    // Instead I use localStorage which saves the information in the user's browser.
    // Maybe: https://create-react-app.dev/docs/title-and-meta-tags#injecting-data-from-the-server-into-the-page
    this.env = {
      hostip: JSON.parse(localStorage.getItem('hostip'))
/*
      hostip:      process.env.REACT_APP_HOST_IP,
      defaultuser: process.env.REACT_APP_DEFAULT_USER,
      defaultpass: process.env.REACT_APP_DEFAULT_PASS,
      domain:      process.env.REACT_APP_DOMAIN,
      admin_email: process.env.REACT_APP_ADMIN_EMAIL,
      timezone:    process.env.REACT_APP_TZ,
      api_secret:  process.env.REACT_APP_API_SECRET
 */
    };
  }

  render() {
    return (
      <Router>
        <div>
          <nav className="navbar navbar-expand navbar-dark bg-dark">
            <a href="/config" className="navbar-brand">
              HomelabOS Control Center
            </a>
            <div className="navbar-nav mr-auto">
              <li className="nav-item">
                <Link to={"/config"} className="nav-link">
                  Configure
                </Link>
              </li>
              <li className="nav-item">
                <Link to={"/service"} className="nav-link">
                  Services
                </Link>
              </li>
              <li className="nav-item">
                <Link to={"/maintenance"} className="nav-link">
                  Maintenance
                </Link>
              </li>
            </div>
          </nav>

          <div className="container mt-3">
            <Switch>
              <Route exact path={["/", "/config"]}
                  render={(props) => <Config {...props} env={this.env} />}
              />
{/*}              <Route exact path="/service" component={Service} /> */}
              <Route exact path="/service"
                  component={(props) => <Service {...props} env={this.env} />}
              />
              <Route exact path="/maintenance"
                  component={(props) => <Maintenance {...props} env={this.env} />}
              />
{/*              <Route path="/somepath/:id" component={somecomponent} /> */}
            </Switch>
          </div>
        </div>
      </Router>
    );
  }
}

export default App;
