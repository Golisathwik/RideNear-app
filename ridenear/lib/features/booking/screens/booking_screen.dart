import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../models/vehicle.dart';
import '../../../providers/app_provider.dart';

class BookingScreen extends StatefulWidget {
  final Vehicle vehicle;
  final DateTime? initialDate;

  const BookingScreen({super.key, required this.vehicle, this.initialDate});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  DateTime? _pickupDate;
  DateTime? _returnDate;
  DateTime? _selectedDate;
  
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  int _durationHours = 24; // Default 1 day

  int get _basePrice {
    if (_durationHours == 12) {
      return (widget.vehicle.pricePerDay * 0.7).round();
    } else {
      int days = _durationHours ~/ 24;
      return widget.vehicle.pricePerDay * days;
    }
  }

  int get _totalPrice {
    return _basePrice + 1250; // Base + Deposit/Taxes
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_pickupDate == null || _returnDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select dates')));
              return;
            }
          }
          if (_currentStep == 1) {
            if (_nameController.text.isEmpty || _licenseController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill KYC details')));
              return;
            }
          }
          
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            // Final step, create booking and show confirmation dialog
            final booking = Booking(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              vehicle: widget.vehicle,
              pickupDate: _pickupDate!,
              returnDate: _returnDate!,
              totalPrice: _totalPrice,
              status: BookingStatus.inProcess,
            );
            
            provider.addBooking(booking);
            provider.addBlockedDates(widget.vehicle.id, _pickupDate!, _returnDate!);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('Booking Confirmed!'),
                content: const Text('Your vehicle has been successfully booked. You can view it in the Bookings tab.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // close booking
                      Navigator.pop(context); // close details
                      provider.setTabIndex(1); // Go to Bookings tab
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentStep == 3 ? 'Pay ₹$_totalPrice' : 'Continue', style: const TextStyle(fontSize: 16)),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Rental Details', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildRentalDetails(theme, provider),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('KYC Verification', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildKYC(theme),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Review', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildReview(theme),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildPayment(theme),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildRentalDetails(ThemeData theme, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duration', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.6))),
        const SizedBox(height: 8),
          SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 15,
            itemBuilder: (context, index) {
              if (index == 0) return _buildDurationChip(theme, 12, '12 Hours', '');
              return _buildDurationChip(theme, index * 24, '$index Day${index > 1 ? 's' : ''}', '');
            },
          ),
        ),
        const SizedBox(height: 24),
        
        Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.6))),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 30,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _selectedDate?.year == date.year && _selectedDate?.month == date.month && _selectedDate?.day == date.day;
              
              // Check if any slot is available this day
              bool isBlocked = true;
              for (int h = 5; h <= 23; h++) {
                DateTime slotStart = DateTime(date.year, date.month, date.day, h);
                DateTime slotEnd = slotStart.add(Duration(hours: _durationHours));
                if (provider.isTimeSlotAvailable(widget.vehicle.id, slotStart, slotEnd)) {
                  isBlocked = false;
                  break;
                }
              }

              return GestureDetector(
                onTap: () {
                  if (!isBlocked) {
                    setState(() {
                      _selectedDate = date;
                      _pickupDate = null;
                      _returnDate = null;
                    });
                  }
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isBlocked ? Colors.grey.withOpacity(0.1) : (isSelected ? theme.primaryColor : theme.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getShortMonth(date.month), 
                        style: TextStyle(fontSize: 10, color: isBlocked ? Colors.grey : (isSelected ? Colors.white : theme.primaryColor))
                      ),
                      Text(
                        '${date.day}', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isBlocked ? Colors.grey : (isSelected ? Colors.white : theme.colorScheme.onSurface))
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        if (_selectedDate != null) ...[
          Text('Select Start Time', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.6))),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 24, // 00:00 to 23:00
              itemBuilder: (context, index) {
                int hour = index; // 0 to 23
                DateTime slotStart = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, hour);
                DateTime slotEnd = slotStart.add(Duration(hours: _durationHours));
                
                bool isAvailable = provider.isTimeSlotAvailable(widget.vehicle.id, slotStart, slotEnd);
                
                // Also block past times if today
                if (slotStart.isBefore(DateTime.now())) {
                  isAvailable = false;
                }

                bool isSelected = _pickupDate != null && _pickupDate!.isAtSameMomentAs(slotStart);

                String timeText = hour > 12 ? '${hour - 12}:00 PM' : (hour == 12 ? '12:00 PM' : (hour == 0 ? '12:00 AM' : '$hour:00 AM'));

                return GestureDetector(
                  onTap: () {
                    if (isAvailable) {
                      setState(() {
                        _pickupDate = slotStart;
                        _returnDate = slotEnd;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: !isAvailable ? Colors.grey.withOpacity(0.1) : (isSelected ? theme.primaryColor : theme.cardColor),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      timeText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: !isAvailable ? Colors.grey : (isSelected ? Colors.white : theme.colorScheme.onSurface),
                        decoration: !isAvailable ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_pickupDate != null && _returnDate != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.calendarCheck, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Drop-off: ${_returnDate!.day} ${_getShortMonth(_returnDate!.month)} at ${_returnDate!.hour > 12 ? _returnDate!.hour - 12 : (_returnDate!.hour == 0 ? 12 : _returnDate!.hour)}:00 ${_returnDate!.hour >= 12 ? 'PM' : 'AM'}',
                      style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildDurationChip(ThemeData theme, int hours, String label, String price) {
    bool isSelected = _durationHours == hours;
    return GestureDetector(
      onTap: () {
        setState(() {
          _durationHours = hours;
          _pickupDate = null;
          _returnDate = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.2)),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? Colors.white : theme.colorScheme.onSurface)),
            // Text(price, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : theme.colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }

  String _getShortMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildKYC(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Full Name', hintText: 'As per ID'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _licenseController,
          decoration: const InputDecoration(labelText: 'License Number'),
        ),
        const SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor ?? Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2), style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.uploadCloud, color: theme.primaryColor),
              const SizedBox(height: 8),
              const Text('Upload Driving License (Front)'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReview(ThemeData theme) {
    String durationText = _durationHours == 12 ? '12 Hours (₹${(widget.vehicle.pricePerDay * 0.7).round()})' : '₹${widget.vehicle.pricePerDay} × ${_durationHours ~/ 24} Days';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(durationText, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('₹$_basePrice', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Security Deposit (Refundable)'),
              Text('₹1000'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Taxes & Fees'),
              Text('₹250'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('₹$_totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayment(ThemeData theme) {
    return Column(
      children: [
        _buildPaymentOption(theme, 'UPI / QR', LucideIcons.smartphone),
        const SizedBox(height: 12),
        _buildPaymentOption(theme, 'Credit / Debit Card', LucideIcons.creditCard, isSelected: true),
        const SizedBox(height: 12),
        _buildPaymentOption(theme, 'Net Banking', LucideIcons.building),
      ],
    );
  }

  Widget _buildPaymentOption(ThemeData theme, String title, IconData icon, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor.withOpacity(0.05) : theme.cardColor,
        border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface)),
          const Spacer(),
          if (isSelected) Icon(LucideIcons.checkCircle, color: theme.primaryColor),
        ],
      ),
    );
  }
}
