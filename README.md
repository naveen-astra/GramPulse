# GramPulse: Village Sustainability Index Tracker

GramPulse is a civic-tech platform designed to empower rural communities, streamline grievance redressal processes, and generate real-time sustainability metrics for villages. It transforms fragmented governance into a transparent and accountable system by bridging the gap between citizens, local agencies, and policymakers.

## Overview

Many rural regions face challenges related to delayed grievance resolution, lack of accountability, and an absence of standardized metrics for measuring village well-being. Issues such as water shortages, road damage, and sanitation failures often lack centralized reporting, tracking, or escalation mechanisms.

GramPulse addresses these challenges through the introduction of a Village Sustainability Index (VSI), a dynamic score that summarizes the health, responsiveness, and resilience of a village based on real-time data across multiple parameters.

## Problem Statement

Current grievance redressal systems rely on scattered and outdated channels such as paper forms, phone calls, or in-person visits. Key challenges include:

- No unified grievance pipeline
- No clear responsibility and ownership of issues
- No visibility into real-time grievance status
- No escalation mechanism based on SLA breaches
- No ground-level data for policymakers
- Lack of transparency and public trust

This leads to unresolved issues, inefficient governance, and limited data-driven decision-making.

## The Solution: Village Sustainability Index (VSI)

GramPulse introduces a real-time updating Village Sustainability Index driven by:

- Grievance volume and resolution rate
- Time taken to close issues versus SLA targets
- Infrastructure-related parameters and recurring issues
- Citizen feedback and satisfaction ratings

Each grievance passes through defined states such as created, assigned, in-progress, resolved, or overdue. Each state change updates the VSI score. All records are traceable, auditable, and visible in a unified public dashboard.

The system enables:

- Transparency, improving trust
- Accountability through SLA tracking
- Data-driven policy making
- Better allocation of resources for critical areas

## How the System Works

1. Citizens submit grievances via a web interface.
2. Issues are assigned automatically to the responsible departments based on category and location.
3. Agencies receive grievances with clearly defined SLA timers.
4. Status changes trigger a recalculation of the VSI and update dashboards.
5. All grievance logs can be audited and reviewed publicly.
6. Web3 hashing ensures data cannot be modified without detection.

## Tech Stack

### Frontend
- React.js  
- Tailwind CSS

### Backend
- Node.js  
- Express.js

### Database and Infrastructure
- PostgreSQL  
- Supabase (Authentication, Database, APIs)
- PostgreSQL Triggers:
  - SLA tracking
  - Change logs
  - Audit trails

### Web3 Integration
- Ethereum Layer 1
- Optimism Layer 2  
- On-chain grievance hash storage for tamper-proof verification

### Deployment
- Vercel for frontend  
- Supabase for backend services and DB hosting

## Web3 Relevance

GramPulse leverages blockchain features to enhance transparency and trust:

- Each grievance generates a content hash stored on-chain.
- Auditors and citizens can independently verify grievance logs.
- Ensures immutability and prevents unauthorized data changes.

Future advancements include decentralized funding (DAO), citizen voting systems, and prioritization of village-level projects.

## Core Features

- Grievance registration with category, severity, and location
- SLA-based tracking and automated escalation
- Real-time VSI scorecard for village sustainability
- Complete grievance history and audit logs
- Public dashboard for citizens, NGOs, and policymakers
- On-chain hashing for verifiable and tamper-proof records

## Impact

- Enables real-time visibility into village needs and risks
- Drives accountability for government agencies and service providers
- Empowers citizens through transparency and accessible grievance data
- Scalable across districts, states, or national deployment

## Roadmap

- MVP with grievance lifecycle and VSI dashboard
- Web3 audit-log integration
- AI module for:
  - Pattern recognition
  - Predictive risk alerts
  - Recurring issue analysis
- DAO-based community budgeting and participation
- District-level pilot testing with civic partners

## Project Structure

GramPulse/
├── frontend/
│   ├── public/
│   └── src/
│       ├── components/
│       ├── pages/
│       ├── hooks/
│       ├── utils/
│       └── styles/
├── backend/
│   ├── controllers/
│   ├── routes/
│   ├── middleware/
│   ├── services/
│   └── db/
├── scripts/
│   ├── triggers.sql
│   ├── audit_logs.sql
│   └── sla_rules.sql
├── docs/
│   ├── architecture_diagram.png
│   ├── api_reference.md
│   └── vsi_formula.md
├── web3/
│   ├── hash_generator.js
│   └── contract_interaction.js
├── config/
│   ├── supabase.json
│   └── env.example
└── README.md



