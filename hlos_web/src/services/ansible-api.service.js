import http from "../http-common";
import sha256 from "sha256";

class AnsibleApiDataService {
  hostip = "";
  api_key = "secret";

  constructor() {
    // Set default host IP from environment if it is defined.
    if(process.env.REACT_APP_HOST_IP !== undefined) {
      this.hostip = process.env.REACT_APP_HOST_IP;
    }
  }
  /*
  getAll() {
    return http.get("/somepage");
  }

  get(id) {
    return http.get(`/somepage/${id}`);
  }

  create(data) {
    return http.post("/somepage", data);
  }

  update(id, data) {
    return http.put(`/somepage/${id}`, data);
  }

  delete(id) {
    return http.delete(`/somepage/${id}`);
  }

  deleteAll() {
    return http.delete(`/somepage`);
  }

  findByTitle(title) {
    return http.get(`/somepage?title=${title}`);
  }
*/

  hasHostIpFromEnv() {
    // Return bool on host IP available from environment variable
    if(process.env.REACT_APP_HOST_IP !== undefined) {
      return true;
    }
    return false;
  }

  setBaseURL(hostip) {
    this.hostip = hostip;
    http.defaults.baseURL="http://"+hostip+":8765/"
  }

  getApi() {
    return http.get(`/`);
  }

  createConfiguration(defaultuser, defaultpass, hostip, domain, admin_email, timezone) {
    let n="config#id@hlos";
    let f="playbook.config.yml";
    let s=sha256(n+hostip+f+this.api_key);
    let data = {
      'n':n,
      'h':hostip,
      'f':f,
      's':s,
      'v_homelab_ip':hostip,
      'v_homelab_ssh_user':'hlos',
      'v_ansible_become_password':'',
      'v_default_username':defaultuser,
      'v_default_password':defaultpass,
      'v_domain':domain,
      'v_admin_email':admin_email,
      'v_volumes_root':'/home/hlos',
      'v_common_timezone':timezone
   };
   return http.post("/playbook", data);
  }

  deploySystem() {
    let n="deploy_host_deps#id@hlos"
    let f="playbook.homelabos_api.yml"
    let s=sha256(n+this.hostip+f+this.api_key);
    let data = {
      "n":n,
      "h":this.hostip,
      "f":f,
      "s":s,
      "e":"/playbooks/settings/config.yml",
      "c_cmd1":"-e \"@/playbooks/settings/vault.yml\"",
      "c_cmd2":"--tags deploy_host_deps"
    }
    return http.post("/playbook", data);
  }

  cryptVault(crypt_mode) {
    let n=crypt_mode+"-vault#id@hlos";
    let m="command";
    let a="docker exec ansible_api_ansible-api_1 ansible-vault "+crypt_mode+" /playbooks/settings/vault.yml";
    let s=sha256(n+m+this.hostip+this.api_key);
    let data = {
      "n":n,
      "m":m,
      "a":a,
      "t":this.hostip,
      "s":s
    };
    return http.post("/command", data);
  }

  setServiceProperty(service_property, value) {
    let n="set_setting#id@hlos";
    let m="shell";
    let a="cd install && ./bootstrap_install/set_setting.sh "+service_property+" "+value;
    let s=sha256(n+m+this.hostip+this.api_key);

    let data = {
      "n":n,
      "m":m,
      "a":a,
      "t":this.hostip,
      "s":s
    };
    console.log(data);
    return http.post("/command", data);
  }

  deployService() {
    let n="deploy#id@hlos";
    let f="playbook.homelabos_api.yml"
    let s=sha256(n+this.hostip+f+this.api_key);

    let data = {
      "n":n,
      "h":this.hostip,
      "f":f,
      "s":s,
      "e":"/playbooks/settings/config.yml",
      "c_cmd1":"-e \"@/playbooks/settings/vault.yml\"",
      "c_cmd2":"--tags deploy_service"
    }
    return http.post("/playbook", data);
  }
} // class

export default new AnsibleApiDataService();
