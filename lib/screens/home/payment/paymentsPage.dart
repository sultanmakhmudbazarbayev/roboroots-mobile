import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // List holding payment card data.
  final List<Map<String, String>> _paymentCards = [
    {
      'cardNumber': '4444 5555 6666 1234',
      'holderName': 'John Doe',
      'expiry': '12/24'
    },
    {
      'cardNumber': '1111 2222 3333 5678',
      'holderName': 'Jane Smith',
      'expiry': '05/23'
    },
  ];

  // Helper function to mask the card number.
  String _maskCardNumber(String cardNumber) {
    // Remove any spaces from the card number.
    final digits = cardNumber.replaceAll(' ', '');
    // Check if we have at least 16 digits.
    if (digits.length < 16) return cardNumber;
    // Create the masked string.
    final masked = '**** **** **** ' + digits.substring(12);
    return masked;
  }

  // Function to show modal bottom sheet for adding a new card.
  void _showAddCardModal() {
    // Controllers for text fields.
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController holderNameController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            // This ensures the modal isn't covered by the keyboard.
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: holderNameController,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final newCard = {
                    'cardNumber': cardNumberController.text,
                    'holderName': holderNameController.text,
                    'expiry': expiryController.text,
                  };

                  // Update the list and rebuild UI.
                  setState(() {
                    _paymentCards.add(newCard);
                  });

                  // Close the modal.
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B6FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Add Card',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Payment Methods",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Payment cards list
              Column(
                children: _paymentCards
                    .map((card) => _buildPaymentCard(card))
                    .toList(),
              ),
              const SizedBox(height: 24),
              // Button to add a new payment card
              ElevatedButton.icon(
                onPressed: _showAddCardModal,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text(
                  "Add New Card",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B6FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each payment card with similar style to the blue cards.
  Widget _buildPaymentCard(Map<String, String> cardData) {
    // Mask the card number using our helper.
    final maskedCardNumber = _maskCardNumber(cardData['cardNumber'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF4B6FFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Payment information text
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  maskedCardNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cardData['holderName'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expiry: ${cardData['expiry'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Right icon for visual enhancement
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.credit_card,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
