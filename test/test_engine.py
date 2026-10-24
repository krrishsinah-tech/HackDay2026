import json
import os
import math
import sys

base_dir = "/Users/jeetganguly/Documents/Notes/To Do/umeed"

def test_l10n_files():
    print("Testing 23 localization files...")
    l10n_dir = os.path.join(base_dir, "assets/l10n")
    required_locales = [
        "en", "hi", "mr", "as", "bn", "brx", "doi", "gu", "kn", "ks",
        "kok", "mai", "ml", "mni", "ne", "or", "pa", "sa", "sat", "sd",
        "ta", "te", "ur"
    ]
    
    assert os.path.exists(l10n_dir), "l10n directory must exist"
    
    # Read base English
    with open(os.path.join(l10n_dir, "en.json"), "r", encoding="utf-8") as f:
        en_keys = set(json.load(f).keys())
    
    assert len(en_keys) >= 40, f"Expected at least 40 translation keys, found {len(en_keys)}"
    
    for loc in required_locales:
        file_path = os.path.join(l10n_dir, f"{loc}.json")
        assert os.path.exists(file_path), f"Locale file {loc}.json missing"
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            # Check key parity
            for key in en_keys:
                assert key in data, f"Key '{key}' missing from {loc}.json"
                
    print("✓ All 23 localization files passed verification with 100% key parity.")

def test_mock_schemes_data():
    print("Testing mock schemes dataset...")
    schemes_file = os.path.join(base_dir, "assets/data/mock_schemes.json")
    assert os.path.exists(schemes_file), "mock_schemes.json must exist"
    
    with open(schemes_file, "r", encoding="utf-8") as f:
        schemes = json.load(f)
        
    assert len(schemes) >= 15, f"Expected 15-20 schemes, found {len(schemes)}"
    
    for s in schemes:
        assert s.get("mock") is True, f"Scheme {s.get('id')} must have mock: true"
        assert "name" in s and len(s["name"]) > 0
        assert "ministry" in s and len(s["ministry"]) > 0
        assert "official_text" in s and len(s["official_text"]) > 0
        assert "simplified_text" in s and len(s["simplified_text"]) > 0
        assert "benefit_amount" in s and s["benefit_amount"] > 0
        assert "benefit_description" in s
        assert "documents_required" in s and len(s["documents_required"]) > 0
        for doc in s["documents_required"]:
            assert "name" in doc
            assert "photo_hint" in doc
            assert "plain_reason" in doc
        assert "apply_url" in s
        assert "physical_office" in s
        assert "last_checked" in s
        assert "ease_score" in s
        assert "eligibility_rules" in s
        
    print(f"✓ All {len(schemes)} mock schemes verified with required fields, photo hints, and plain-words explanations.")

def calculate_eligibility_score(rules, profile):
    score = 0.0
    criteria_checked = 0
    
    if "age" in profile and profile["age"] is not None:
        criteria_checked += 1
        if rules["min_age"] <= profile["age"] <= rules["max_age"]:
            score += 1.0
        else:
            return 0.0
            
    if "gender" in profile and profile["gender"] is not None:
        criteria_checked += 1
        allowed = [g.lower() for g in rules.get("genders", ["ALL"])]
        if "all" in allowed or profile["gender"].lower() in allowed:
            score += 1.0
        else:
            return 0.0
            
    if "occupation" in profile and profile["occupation"] is not None:
        criteria_checked += 1
        allowed = [o.lower() for o in rules.get("occupations", ["ALL"])]
        if profile["occupation"].lower() in allowed:
            score += 1.3
        elif "all" in allowed:
            score += 1.0
        else:
            return 0.0

    if rules.get("requires_disability", False):
        criteria_checked += 1
        if profile.get("has_disability") is True:
            score += 1.5
        else:
            return 0.0
            
    if "area" in profile and profile["area"] is not None:
        criteria_checked += 1
        allowed = [a.lower() for a in rules.get("areas", ["ALL"])]
        if profile["area"].lower() in allowed:
            score += 1.1
        elif "all" in allowed:
            score += 1.0
        else:
            return 0.0
            
    if "annual_income" in profile and profile["annual_income"] is not None:
        criteria_checked += 1
        if profile["annual_income"] <= rules.get("max_annual_income", 99999999):
            score += 1.0
        else:
            return 0.0
            
    if criteria_checked == 0:
        return 0.7
    return score / criteria_checked

def calculate_benefit_score(amount):
    if amount <= 0:
        return 0.2
    return max(0.1, min(1.0, math.log(amount) / math.log(500000)))

def rank_schemes(schemes, profile):
    ranked = []
    for s in schemes:
        elig = calculate_eligibility_score(s["eligibility_rules"], profile)
        if elig <= 0.0:
            continue
        benefit = calculate_benefit_score(s["benefit_amount"])
        ease = s.get("ease_score", 0.8)
        overall = (elig * 0.50) + (benefit * 0.30) + (ease * 0.20)
        ranked.append({"scheme": s, "score": overall, "eligibility": elig})
        
    ranked.sort(key=lambda x: x["score"], reverse=True)
    return ranked

def test_ranking_algorithm():
    print("Testing ranking engine & demographic gating...")
    schemes_file = os.path.join(base_dir, "assets/data/mock_schemes.json")
    with open(schemes_file, "r", encoding="utf-8") as f:
        schemes = json.load(f)
        
    # Scenario 1: Rural Farmer
    farmer_profile = {
        "name": "Suresh",
        "age": 42,
        "gender": "man",
        "area": "rural",
        "occupation": "farmer",
        "annual_income": 120000
    }
    ranked_farmer = rank_schemes(schemes, farmer_profile)
    assert len(ranked_farmer) > 0
    top_ids = [r["scheme"]["id"] for r in ranked_farmer[:3]]
    # PM-KISAN or KCC should be in top results for rural farmer
    assert any(k in top_ids for k in ["pm_kisan", "kisan_credit_card", "ayushman_bharat"]), f"Expected farmer scheme in top, got {top_ids}"
    
    # Scenario 2: Urban Street Vendor / Business
    vendor_profile = {
        "name": "Manoj",
        "age": 30,
        "gender": "man",
        "area": "urban",
        "occupation": "business",
        "annual_income": 180000
    }
    ranked_vendor = rank_schemes(schemes, vendor_profile)
    vendor_top_ids = [r["scheme"]["id"] for r in ranked_vendor[:3]]
    assert "pm_svanidhi" in vendor_top_ids or "pm_egp" in vendor_top_ids
    
    # Scenario 3: Gender Exclusion
    male_profile = {"gender": "man", "age": 25}
    for r in rank_schemes(schemes, male_profile):
        assert r["scheme"]["id"] not in ["pm_matru_vandana", "sukanya_samriddhi"], "Male cannot qualify for maternity or girl child savings"
        
    print("✓ Ranking engine correctly prioritized schemes and enforced hard exclusion rules.")

if __name__ == "__main__":
    try:
        test_l10n_files()
        test_mock_schemes_data()
        test_ranking_algorithm()
        print("\nALL VERIFICATION TESTS PASSED SUCCESSFULLY! (100% PASS)")
    except Exception as e:
        print(f"FAILED: {e}")
        sys.exit(1)
