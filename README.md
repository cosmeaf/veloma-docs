# Project Requirements

This document describes the requirements and dependencies needed to run the IPINTEL project.

---

## System Requirements

The following software must be installed on the system:

- Python 3.9 or higher
- pip (Python package manager)
- Git
- Linux / macOS / Windows environment

---

## Python Dependencies

The project requires the following Python libraries:

- geoip2
- requests
- python-dotenv
- dnspython

These dependencies can be installed using:

pip install -r requirements.txt

---

## External Data Requirements

IPINTEL requires external intelligence datasets to perform analysis.

### GeoIP Database

The GeoIP database is required for geolocation.

Recommended database:

GeoLite2 City Database

Download from:

https://dev.maxmind.com/geoip/geolite2-free-geolocation-data/

After downloading, place the file in:

data/GeoLite2-City.mmdb

---

### TOR Exit Node List

The TOR module requires a list of TOR exit nodes.

Example source:

https://check.torproject.org/exit-addresses

The list should be saved in the project data directory.

---

### Proxy List

Proxy detection requires a proxy IP dataset.

This dataset should be periodically updated from trusted proxy intelligence sources.

---

### Datacenter ASN List

Datacenter detection requires a list of ASNs belonging to cloud and hosting providers.

Examples include:

- Amazon AWS
- Google Cloud
- Microsoft Azure
- DigitalOcean
- OVH
- Linode

---

## Environment Configuration

Environment variables can be configured using a `.env` file.

Example configuration:

GEOIP_DB=data/GeoLite2-City.mmdb  
CACHE_TTL=86400  
API_LOOKUP=false  

---

## Development Requirements

For development and testing:

- Python virtual environment recommended
- pytest (optional for testing)
- Git for version control

---

## Recommended Tools

For development and debugging:

- VS Code or similar editor
- Python debugger
- Linux shell environment

---

## Security Considerations

- Do not expose internal investigation engines without proper API protection
- Avoid exposing raw WHOIS data in public APIs
- Keep intelligence datasets updated
- Monitor external data sources for integrity

---

## Future Requirements

Potential future dependencies:

- Redis (caching layer)
- FastAPI (REST API interface)
- Uvicorn (API server)
- Shodan API integration
- AbuseIPDB integration
