import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = {
    enableTime: { type: Boolean, default: false },
    placeholder: { type: String, default: "Choose Date" }
  }

  connect() {
    const inputClass =
      "flatpickr-alt-btn bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 " +
      "text-sm cursor-pointer"

    this.picker = flatpickr(this.element, {
      altInput: true,
      altInputClass: inputClass,
      altFormat: this.enableTimeValue ? "m/d/Y h:i K" : "F j, Y",
      dateFormat: this.enableTimeValue ? "Y-m-d\\TH:i" : "Y-m-d",
      enableTime: this.enableTimeValue,
      clickOpens: true,
      allowInput: false,
      onChange: () => {
        this.element.dispatchEvent(new Event("input", { bubbles: true }))
      },
      onReady: (_selectedDates, _dateStr, instance) => {
        instance.altInput.placeholder = this.placeholderValue
        instance.altInput.setAttribute("readonly", "readonly")
        instance.altInput.style.caretColor = "transparent"
        instance.altInput.style.width = "auto"

        const doneBtn = document.createElement("button")
        doneBtn.textContent = "Done"
        doneBtn.type = "button"
        doneBtn.className =
          "flatpickr-done-btn w-full py-2 bg-blue-600 text-white text-sm font-medium " +
          "rounded-b hover:bg-blue-700 cursor-pointer"
        doneBtn.addEventListener("click", () => instance.close())
        instance.calendarContainer.appendChild(doneBtn)
      }
    })
  }

  disconnect() {
    if (this.picker) {
      this.picker.destroy()
    }
  }
}
