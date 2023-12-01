import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activity"
export default class extends Controller {
  static values = {
    userid: Number
  }
  connect() {
    const observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      root: null, // use the viewport as the root
      rootMargin: "0px", // no margin
      threshold: 0.5, // trigger when 50% of the element is in view
    });

    observer.observe(this.element);
  }

  handleIntersection(entries, observer) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        // The element is now in view
        this.createEncounter();
        observer.unobserve(entry.target); // stop observing once triggered
      }
    });
  }

  createEncounter() {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10)
    fetch('/encounters', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_id: this.useridValue,
        activity_id: activityID
      }),
    })
  }
}
