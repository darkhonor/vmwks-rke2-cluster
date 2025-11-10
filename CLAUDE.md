# CLAUDE.md - DoD STIG & NIST SP800-53 Compliance Configuration

**Last Modified:** 2025-11-09  
**Purpose:** Enforce DoD Security Technical Implementation Guide (STIG) and NIST SP800-53 compliance across all Claude responses  
**Standards:** DoD STIGs, NIST SP800-53 Rev 5, FIPS 140-2/140-3

---

## MANDATORY COMPLIANCE DIRECTIVES

Claude MUST enforce the following security standards for ALL responses, code generation, and artifacts:

### 1. CRYPTOGRAPHIC REQUIREMENTS (FIPS 140-2/140-3)

**ENFORCE:**
- All cryptographic operations MUST use FIPS 140-2 or FIPS 140-3 validated modules
- Minimum key lengths:
  - RSA: 2048 bits (3072+ recommended)
  - ECC: 256 bits (384+ recommended)
  - AES: 256 bits
  - SHA: SHA-256 or higher (NO SHA-1, NO MD5)
- TLS 1.2 minimum (TLS 1.3 preferred)
- Certificate validation MUST be enforced
- NO hardcoded cryptographic keys, passwords, or secrets

**PROHIBITED:**
- DES, 3DES, RC4, MD5, SHA-1
- Self-signed certificates in production
- Insecure random number generators
- Custom cryptographic implementations

### 2. AUTHENTICATION & ACCESS CONTROL (NIST SP800-53: IA, AC)

**ENFORCE:**
- Multi-factor authentication (MFA) for privileged access
- Role-Based Access Control (RBAC) or Attribute-Based Access Control (ABAC)
- Principle of least privilege
- Account lockout after failed attempts (max 3-5 attempts)
- Password complexity requirements:
  - Minimum 15 characters (DoD standard)
  - Mix of uppercase, lowercase, numbers, special characters
  - Password history (minimum 24 generations)
  - Maximum password age: 60 days
- Session timeout: 15 minutes of inactivity (30 max)
- Concurrent session limits

**PROHIBITED:**
- Default credentials
- Hardcoded passwords
- Passwordless authentication without compensating controls
- Anonymous access to sensitive data

### 3. AUDIT & ACCOUNTABILITY (NIST SP800-53: AU)

**ENFORCE:**
- Comprehensive logging of:
  - Authentication attempts (success/failure)
  - Authorization decisions
  - Data access and modifications
  - Administrative actions
  - Security events
- Log integrity protection (hashing, signing)
- Centralized log management
- Log retention: minimum 1 year (3 years for high-impact systems)
- Time synchronization (NTP)
- Audit record review processes

**LOG FORMAT REQUIREMENTS:**
- Timestamp (UTC)
- User/process identity
- Event type
- Success/failure indication
- Source/destination addresses
- Data sensitivity labels

### 4. SECURE CODING PRACTICES (NIST SP800-53: SA, SI)

**ENFORCE:**
- Input validation (whitelist approach)
- Output encoding
- Parameterized queries (NO string concatenation for SQL)
- Secure error handling (NO sensitive data in error messages)
- Security headers:
  - Content-Security-Policy
  - X-Frame-Options: DENY
  - X-Content-Type-Options: nosniff
  - Strict-Transport-Security
  - X-XSS-Protection
- Secure session management
- CSRF protection
- Memory-safe practices (bounds checking, null checks)

**PROHIBITED:**
- SQL injection vectors
- Command injection vectors
- Path traversal vulnerabilities
- XML external entity (XXE) processing
- Deserialization of untrusted data
- Use of dangerous functions (eval, exec, system)
- Information disclosure in errors

### 5. DATA PROTECTION (NIST SP800-53: SC, MP)

**ENFORCE:**
- Data classification labels (CUI, PII, PHI, etc.)
- Encryption at rest (FIPS 140-2/3 validated)
- Encryption in transit (TLS 1.2+)
- Secure key management (HSM or KMS)
- Data sanitization before disposal (DoD 5220.22-M)
- Database security:
  - Encrypted connections
  - Stored procedure use
  - Principle of least privilege for DB accounts
  - Database activity monitoring

**DATA HANDLING:**
- PII/CUI requires encryption + access controls
- No sensitive data in logs, URLs, or GET parameters
- Secure temporary file handling
- Memory clearing after sensitive operations

### 6. NETWORK SECURITY (NIST SP800-53: SC)

**ENFORCE:**
- Network segmentation
- Firewall rules (default deny)
- Intrusion detection/prevention
- DDoS protection
- Rate limiting
- IP whitelisting where applicable
- Disable unnecessary services and ports
- Certificate pinning for critical connections

### 7. VULNERABILITY MANAGEMENT (NIST SP800-53: RA, SI)

**ENFORCE:**
- Dependency scanning
- Static Application Security Testing (SAST)
- Dynamic Application Security Testing (DAST)
- Software Composition Analysis (SCA)
- Regular security patching (critical within 30 days)
- Vulnerability disclosure program
- Penetration testing requirements

### 8. CONTAINER & CLOUD SECURITY (DoD Container STIG, NIST SP800-53)

**ENFORCE:**
- Container image scanning
- Minimal base images (distroless preferred)
- Non-root container execution
- Resource limits (CPU, memory)
- Secrets management (NOT in environment variables)
- Pod security policies/standards
- Service mesh for mTLS
- Network policies

### 9. DATABASE SECURITY (DoD Database STIGs)

**ENFORCE:**
- Database encryption (TDE)
- Parameterized queries/prepared statements
- Least privilege database accounts
- Audit logging of database access
- Regular backups with encryption
- Database hardening per vendor STIG
- Connection pooling with secure configurations

### 10. INCIDENT RESPONSE (NIST SP800-53: IR)

**REQUIRE:**
- Incident response plan reference
- Security contact information
- Incident logging procedures
- Evidence preservation procedures
- Breach notification compliance (FISMA, etc.)

---

## MANDATORY FILE HEADER FORMAT

ALL generated files MUST include a header comment appropriate to the language:

### Python Example:
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Filename: secure_app.py
Last Modified: 2025-11-09
Summary: Secure application implementing user authentication with MFA
Compliant With: DoD STIG, NIST SP800-53 Rev 5, FIPS 140-2
Classification: CUI (if applicable)
"""
```

### JavaScript/TypeScript Example:
```javascript
/**
 * Filename: auth-service.ts
 * Last Modified: 2025-11-09
 * Summary: Authentication service with FIPS-compliant cryptography
 * Compliant With: DoD STIG, NIST SP800-53 Rev 5, FIPS 140-3
 * Classification: UNCLASSIFIED
 */
```

### Java Example:
```java
/**
 * Filename: SecureDataHandler.java
 * Last Modified: 2025-11-09
 * Summary: Secure data processing with encryption and audit logging
 * Compliant With: DoD STIG, NIST SP800-53 Rev 5, FIPS 140-2
 * Author: [Organization]
 * Classification: CUI
 */
```

### C/C++ Example:
```c
/*
 * Filename: crypto_module.c
 * Last Modified: 2025-11-09
 * Summary: FIPS 140-2 compliant cryptographic operations module
 * Compliant With: DoD STIG, NIST SP800-53 Rev 5, FIPS 140-2
 * Classification: UNCLASSIFIED
 */
```

### SQL Example:
```sql
-- Filename: secure_schema.sql
-- Last Modified: 2025-11-09
-- Summary: Database schema with security controls and audit tables
-- Compliant With: DoD Database STIG, NIST SP800-53 Rev 5
-- Classification: CUI
```

### YAML/Config Example:
```yaml
# Filename: security-config.yaml
# Last Modified: 2025-11-09
# Summary: Security configuration for Kubernetes deployment
# Compliant With: DoD Container STIG, NIST SP800-53 Rev 5, FIPS 140-3
# Classification: UNCLASSIFIED
```

---

## SECURITY CONTROL FAMILIES (NIST SP800-53 Rev 5)

All responses must consider these control families:

- **AC** - Access Control
- **AT** - Awareness and Training
- **AU** - Audit and Accountability
- **CA** - Assessment, Authorization, and Monitoring
- **CM** - Configuration Management
- **CP** - Contingency Planning
- **IA** - Identification and Authentication
- **IR** - Incident Response
- **MA** - Maintenance
- **MP** - Media Protection
- **PE** - Physical and Environmental Protection
- **PL** - Planning
- **PM** - Program Management
- **PS** - Personnel Security
- **PT** - PII Processing and Transparency
- **RA** - Risk Assessment
- **SA** - System and Services Acquisition
- **SC** - System and Communications Protection
- **SI** - System and Information Integrity
- **SR** - Supply Chain Risk Management

---

## COMPLIANCE VERIFICATION CHECKLIST

Before delivering ANY code or configuration, verify:

- [ ] FIPS 140-2/140-3 compliant cryptography
- [ ] No hardcoded secrets or credentials
- [ ] Input validation and output encoding
- [ ] Secure error handling
- [ ] Audit logging implemented
- [ ] Authentication and authorization controls
- [ ] Session management security
- [ ] Secure communication (TLS 1.2+)
- [ ] Proper file header with compliance statement
- [ ] Least privilege principles applied
- [ ] Security headers configured
- [ ] Vulnerability scanning recommendations included
- [ ] Documentation includes security considerations

---

## RESPONSE FORMAT

When generating code or configurations, Claude MUST:

1. **Include the mandatory file header** with all required fields
2. **Document security controls** in comments
3. **Explain compliance rationale** for key security decisions
4. **Highlight areas requiring additional review** by security team
5. **Provide security testing recommendations**
6. **Reference specific STIG/NIST controls** addressed

---

## PROHIBITED PRACTICES

Claude MUST REFUSE to generate code that:

- Uses deprecated or insecure cryptographic algorithms
- Implements custom cryptography
- Includes hardcoded credentials
- Disables security features
- Violates least privilege
- Lacks input validation
- Exposes sensitive data in logs/errors
- Uses vulnerable dependencies (when known)
- Implements insecure deserialization

---

## ADDITIONAL REQUIREMENTS

- **Configuration Management**: All configurations must follow Infrastructure as Code (IaC) principles with version control
- **Secrets Management**: Use dedicated secrets management solutions (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault)
- **Compliance Documentation**: Generate security documentation alongside code
- **Risk Assessment**: Identify residual risks requiring acceptance
- **Continuous Monitoring**: Recommend monitoring and alerting configurations

---

## UPDATES AND MAINTENANCE

This compliance configuration must be reviewed and updated:
- Quarterly or when new STIGs are released
- When NIST SP800-53 revisions are published
- When FIPS 140-3 becomes mandatory
- After security incidents or audit findings

---

**ENFORCEMENT LEVEL: MANDATORY**  
All deviations require formal risk acceptance and compensating controls documentation.
