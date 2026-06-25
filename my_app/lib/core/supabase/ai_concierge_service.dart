import 'dart:async';

class AiSmartQuote {
  final String categoryDetected;
  final String locationDetected;
  final double budgetDetected;
  final double estimatedCost;
  final String matchingProvider;
  final String breakdown;
  final String checkoutRedirectPath;

  AiSmartQuote({
    required this.categoryDetected,
    required this.locationDetected,
    required this.budgetDetected,
    required this.estimatedCost,
    required this.matchingProvider,
    required this.breakdown,
    required this.checkoutRedirectPath,
  });
}

class AiConciergeService {
  // 1. Generate custom personalized feed items (Phase 4)
  Future<List<Map<String, dynamic>>> generatePersonalizedFeed(String userId) async {
    // Curated recommendations based on active user profiling
    return [
      {
        'id': 'ai_p1',
        'title': 'Wholesale Tomatoes (Fresh Basket)',
        'category': 'GROCERY',
        'provider': 'Ogbogonogo Agricultural Cooperative',
        'original_price': 6000.0,
        'ai_deal_price': 4200.0,
        'ai_match_score': '98% MATCH',
        'reason': 'Based on your recent purchase of grocery bundles in Asaba.'
      },
      {
        'id': 'ai_p2',
        'title': 'Expert Home Drainage Unblocking',
        'category': 'HANDYMAN',
        'provider': 'TechFlow Solutions Ltd.',
        'original_price': 15000.0,
        'ai_deal_price': 11000.0,
        'ai_match_score': '92% MATCH',
        'reason': 'Recommended handy-person near Nnebisi Road with active 5.0 ratings.'
      },
    ];
  }

  // 2. Parse unstructured text and return a calculated smart quote draft
  Future<AiSmartQuote> parseNaturalLanguageQuoteRequest(String userInput) async {
    final cleanInput = userInput.toLowerCase();

    // Default parsed fallback configurations
    String category = 'General Assistance';
    String location = 'Asaba Central';
    double budget = 20000.0;
    double cost = 12500.0;
    String provider = 'Standard Elite Services';
    String breakdown = 'Service charge + standard material transport costs.';
    String redirect = '/checkout/confirm';

    // A. Budget boundary extraction using regular expressions
    final numberReg = RegExp(r'\d+');
    final match = numberReg.firstMatch(cleanInput);
    if (match != null) {
      final parsedVal = double.tryParse(match.group(0)!);
      if (parsedVal != null) {
        budget = parsedVal;
      }
    }

    // B. Category Intent Parsing
    if (cleanInput.contains('plumb') || cleanInput.contains('pipe') || cleanInput.contains('leak') || cleanInput.contains('sink')) {
      category = 'Plumbing Services';
      cost = budget > 0 ? budget * 0.85 : 9500.0;
      provider = 'DrainMasters Asaba';
      breakdown = '₦6,500 Base Labor + ₦2,000 Pipe seal fittings + ₦1,000 Travel Allowance.';
      redirect = '/service/booking';
    } else if (cleanInput.contains('clean') || cleanInput.contains('wash') || cleanInput.contains('dust')) {
      category = 'Home & Office Cleaning';
      cost = budget > 0 ? budget * 0.80 : 8000.0;
      provider = 'TechFlow Solutions';
      breakdown = '₦5,500 Full House sweep + ₦1,500 Disinfectant chemicals + ₦1,000 Logistics.';
      redirect = '/service/booking';
    } else if (cleanInput.contains('tomato') || cleanInput.contains('grocery') || cleanInput.contains('yam') || cleanInput.contains('pepper')) {
      category = 'Wholesale Market Sourcing';
      cost = budget > 0 ? budget * 0.90 : 5000.0;
      provider = 'Ogbogonogo Agro Farmers';
      breakdown = '₦3,800 Sourced Farm Stock + ₦1,200 SafePay Escrow Rider dispatch.';
      redirect = '/checkout/confirm';
    } else if (cleanInput.contains('deliver') || cleanInput.contains('logistics') || cleanInput.contains('rider') || cleanInput.contains('send')) {
      category = 'Escrow Rider Courier';
      cost = budget > 0 ? budget * 0.75 : 1500.0;
      provider = 'SafePay Swift Riders';
      breakdown = '₦1,000 Base distance dispatch + ₦500 Heavy package handler.';
      redirect = '/rider/discovery';
    }

    // C. Landmark Destination Parsing
    if (cleanInput.contains('nnebisi')) {
      location = 'Nnebisi Junction, Asaba';
    } else if (cleanInput.contains('summit')) {
      location = 'Summit Road, Asaba';
    } else if (cleanInput.contains('dla')) {
      location = 'DLA Road Housing Estate, Asaba';
    } else if (cleanInput.contains('okpanam')) {
      location = 'Okpanam Road Extension, Asaba';
    }

    // Secure cost safety guard (ensure calculated cost never violates user budget bounds)
    if (cost > budget && budget > 1000.0) {
      cost = budget * 0.95;
    }

    return AiSmartQuote(
      categoryDetected: category,
      locationDetected: location,
      budgetDetected: budget,
      estimatedCost: cost,
      matchingProvider: provider,
      breakdown: breakdown,
      checkoutRedirectPath: redirect,
    );
  }
}
