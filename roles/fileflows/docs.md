# FileFlows

[FileFlows](https://fileflows.com/) is a file processing automation tool that allows you to create workflows for processing files, including video transcoding, image manipulation, and more.

## Configuration

FileFlows provides a web-based interface for creating and managing file processing workflows. The service includes both a server component and an internal processing node.

### Volumes

FileFlows uses several volume mounts:

- **Data Directory**: Stores configuration and essential data (`/data`)
- **Logs Directory**: Stores all log files (`/logs`)
- **Temp Directory**: Temporary files during flow execution (`/temp`)
- **Docker Socket**: Required for Docker-based processing (`/var/run/docker.sock`)

### Optional Configuration

You can configure additional options in your `settings/fileflows.yml`:

- `temp_path`: Custom temporary directory path (defaults to `/temp` in container)
- `browser_start_directory`: Initial folder location in the file browser (defaults to `/media`)
- `common_directory`: Shared location for DockerMods installations
- `additional_volumes`: Additional volume mappings for processing external directories
- `oidc_authority`: OpenID Connect authority URL (requires license)
- `oidc_client_id`: OIDC client ID
- `oidc_client_secret`: OIDC client secret
- `oidc_callback_address`: OIDC callback URL
- `oidc_required_group`: Required OIDC group for access

### Hardware Acceleration

FileFlows supports hardware acceleration through DockerMods. The container can be configured with:

- **NVIDIA GPU**: For GPU-accelerated video processing
- **Intel QSV**: For Intel Quick Sync Video acceleration

These features require additional Docker configuration and are typically handled through DockerMods or custom container configurations.

## Usage

1. Access the FileFlows web interface
2. Create flows using the visual flow editor
3. Configure libraries to monitor for file processing
4. Set up processing nodes (the server includes an internal node)

## Access

FileFlows is available at [https://{% if fileflows.domain %}{{ fileflows.domain }}{% else %}{{ fileflows.subdomain + "." + domain }}{% endif %}/](https://{% if fileflows.domain %}{{ fileflows.domain }}{% else %}{{ fileflows.subdomain + "." + domain }}{% endif %}/) or [http://{% if fileflows.domain %}{{ fileflows.domain }}{% else %}{{ fileflows.subdomain + "." + domain }}{% endif %}/](http://{% if fileflows.domain %}{{ fileflows.domain }}{% else %}{{ fileflows.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ fileflows.subdomain + "." + tor_domain }}/](http://{{ fileflows.subdomain + "." + tor_domain }}/)
{% endif %}

## Documentation

For more information, visit the [FileFlows Documentation](https://fileflows.com/docs/).


