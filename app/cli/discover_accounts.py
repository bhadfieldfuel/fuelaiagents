# app/cli/discover_accounts.py

from typing import Dict, List
from app.agents.discovery_agent import suggest_accounts_for_brand


def main():
    # You can make these configurable later; hard-coded for FuelAI for now
    brand_name = "FuelAI"
    brand_description = (
        "FuelAI is an AI-powered platform that automates lead engagement, appointment scheduling, "
        "and sales follow-ups across multiple channels (email, text, voicemail, live chat, Facebook Messenger). "
        "It enables businesses to scale their sales efforts without increasing team workload, delivering authentic "
        "human-like communication 24/7 that mirrors your brand's tone and voice."
    )
    target_audience = (
        "B2B SaaS founders, sales leaders, SDR/BDR managers, RevOps leaders, and founder-led sales teams "
        "who want to respond faster, follow up smarter, and book more meetings without additional hires. "
        "Teams focused on pipeline generation, outbound efficiency, and scaling sales without just hiring more headcount."
    )

    existing_handles: Dict[str, List[str]] = {
        "instagram": ["getfuelai"],
        "facebook": ["Fuel AI"],
        "linkedin": ["fuelAI"],
    }

    suggestions = suggest_accounts_for_brand(
        brand_name=brand_name,
        brand_description=brand_description,
        target_audience=target_audience,
        existing_handles=existing_handles,
        max_suggestions=15,
    )

    if not suggestions:
        print("No suggestions returned.")
        return

    print("\n=== Suggested Accounts ===\n")
    for i, s in enumerate(suggestions, start=1):
        print(f"{i:2d}. [{s['platform']}] {s['handle']}  ({s['display_name']})")
        print(f"    type: {s['type']}  fit_score: {s['fit_score']:.2f}")
        if s.get("reason"):
            print(f"    reason: {s['reason']}")
        print()

    print("You can add any of these into the `sources` table, e.g.:")
    print("""
insert into sources (platform, handle, is_competitor, fetch_schedule)
values ('instagram', 'some_handle', true, 'daily');
""")


if __name__ == "__main__":
    main()