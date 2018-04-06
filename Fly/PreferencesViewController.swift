import UIKit

protocol PreferencesViewControllerDelegate {
    func didUpdatePreferences(holiday: Holiday)
}


class PreferencesViewController: UIViewController {

    @IBOutlet weak var budgetLabel: UILabel!
    
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var departureButton: UIButton!
    @IBOutlet weak var tripLengthButton: UIButton!
    
    @IBOutlet weak var budgetSlider: UISlider!

    @IBOutlet weak var tripLengthPickerView: UIPickerView!
    @IBOutlet weak var flyOutPickerView: UIPickerView!
    
    let tripDurations = TripType.all
    let departureOptions: [Departure] = [.nextWeekend, .thisWeekend, .nextThreeMonths, .anytime]
    var budget: Int = 150
    
    var delegate: PreferencesViewControllerDelegate?
    
    override func viewDidLoad() {
        didChangeBudget(budgetSlider)
        hidePickerViews()
    }
    
    @IBAction func didChangeBudget(_ sender: UISlider) {
        budgetLabel.text = "\(Int(sender.value)) EUR"
        budget = Int(sender.value)
    }
    
    @IBAction func didTapOrigin(_ sender: UIButton) {

    }
    
    @IBAction func didTapFlyOutDate(_ sender: UIButton) {
        if !flyOutPickerView.isHidden { return hidePickerViews() }
        hidePickerViews()
        flyOutPickerView.isHidden = false
    }
    

    @IBAction func didTapTripLength(_ sender: UIButton) {
        if !tripLengthPickerView.isHidden { return hidePickerViews() }
        hidePickerViews()
        tripLengthPickerView.isHidden = false
    }
    
    func hidePickerViews() {
        tripLengthPickerView.isHidden = true
        flyOutPickerView.isHidden = true
    }
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        let holiday = Holiday(on: departureOptions[flyOutPickerView.selectedRow(inComponent: 0)], duration: tripDurations[tripLengthPickerView.selectedRow(inComponent: 0)], budget: Int(budgetSlider.value))
        
        delegate?.didUpdatePreferences(holiday: holiday)
        
        navigationController?.popViewController(animated: true)
    }
}

extension PreferencesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hidePickerViews()
        pickerView == flyOutPickerView ? departureButton.setTitle("\(departureOptions[row])", for: .normal) : tripLengthButton.setTitle("\(tripDurations[row])", for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == flyOutPickerView ? "\(departureOptions[row])" : "\(tripDurations[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == flyOutPickerView ? departureOptions.count : tripDurations.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
