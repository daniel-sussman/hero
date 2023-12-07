import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activity"
export default class extends Controller {
  static targets = ['heart', 'attended', 'stars', 'review', 'link', 'menu', 'ellipsis', 'options', 'fewer', 'save', 'modal', 'collection', 'form']
  static values = {
    userid: Number,
    encounterid: Number
  }
  connect() {
    const observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      root: null, // use the viewport as the root
      rootMargin: "0px", // no margin
      threshold: 0.5, // trigger when 50% of the element is in view
    });
    this.closed = true
    this.ratingBox = false
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

  like() {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10)
    fetch(`/activities/${activityID}/like`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    this.heartTarget.classList.toggle("heart-regular")
    this.heartTarget.classList.toggle("heart-solid")
  }

  attended() {
    if (this.ratingBox) {
      this.shrinkRatingBox()
    } else {
      this.expandRatingBox()
    }
  }

  expandRatingBox() {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10)

    fetch(`/activities/${activityID}/attended`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })

    this.starsTarget.classList.remove("d-none");
    this.reviewTarget.classList.remove("d-none");
    this.attendedTarget.classList.add("d-none");
    this.linkTarget.classList.add("expanded");
    this.ratingBox = true;

    document.addEventListener('click', (e) => {
      if (this.linkTarget == e.target || this.linkTarget.contains(e.target)) {
        // pressed on me so stay
      } else {
        this.shrinkRatingBox()
      }
    })
  }

  shrinkRatingBox() {
    this.starsTarget.classList.add("d-none");
    this.reviewTarget.classList.add("d-none");
    this.attendedTarget.classList.remove("d-none");
    this.linkTarget.classList.remove("expanded");
    this.ratingBox = false
  }

  rate(event) {
    if (event.target.classList.contains("star")) {
      const rating = event.target.getAttribute("data-rating");
      const activityID = parseInt(this.element.getAttribute('data-value'), 10);

      fetch(`/activities/${activityID}/rating`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          rating: parseInt(rating, 10),
        }),
      });

      // Update the checkmark text based on the selected rating
      for (let i = 1; i <= 5; i++) {
        this.attendedTarget.classList.remove(`star-${i}`);
      }
      this.attendedTarget.classList.add('star')
      this.attendedTarget.classList.add(`star-${rating}`);
      this.attendedTarget.classList.remove('checkmark')

      this.shrinkRatingBox()
      // this.attendedTarget.innerHTML = `<span><i class='star'></i></span> Rated ${rating}`;
    }
  }

  review() {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10)
    fetch(`/activities/${activityID}#review`, {
      method: 'GET',
    });
  }

  expand(event) {
    if (event.target.classList.contains("option")) {
      const datamodel = document.querySelector(".bd-example-modal-lg");
      datamodel.model(show);
    }

    this.modalTarget.classList.add('show')
    setTimeout(() => {
      this.closed = false
    }, 300);
    document.addEventListener('click', (e) => {
      if (this.modalTarget == e.target || this.modalTarget.contains(e.target)) {
        // pressed on card so stay
      } else {
        // we gooooo
        if (!this.closed) {
          this.collapse()
        }
      }
    })
  }

  collapse() {
    this.closed = true
    this.modalTarget.classList.remove('show')
  }

  fewer() {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10);

    fetch(`/activities/${activityID}/fewer`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    });
  }

  save(event) {
    const activityID = parseInt(this.element.getAttribute('data-value'), 10);

    fetch(`/activities/${activityID}/save`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    });

    this.collectionTargets.forEach(targ => {
      if (targ.contains(event.target)) {
        const collectionID = parseInt(targ.getAttribute('data-id'), 10);

        fetch(`/collections/${collectionID}/add_activity`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({
            encounter_id: this.encounteridValue
          }),
        }).then(response => response.json())
        .then((data) => {
          if (data.modal) this.modalTarget.outerHTML = data.modal
        })
        this.saveTarget.classList.remove("save")
        this.saveTarget.classList.add("saved")
        this.collapse()
      }
    })
    if (!this.closed) {
      // THERE IS A BUG HERE! Check if user clicked the bookmark icon
      this.saveTarget.classList.toggle("save")
      this.saveTarget.classList.toggle("saved")

      // If the activity was unsaved, remove it from collections
      if (this.saveTarget.classList.contains("save")) {
        fetch(`/collections/remove_activity`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({
            encounter_id: this.encounteridValue
          }),
        })
      }
    }
  }

  new_collection() {
    this.formTarget.classList.remove("d-none")
    // fetch(`/collections/${collectionID}/add_activity`, {
    //   method: 'POST',
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    //   },
    //   body: JSON.stringify({
    //     encounter_id: this.encounteridValue
    //   }),
    // }).then(response => response.json())
    // .then((data) => {
    //   if (data.modal) this.modalTarget.outerHTML = data.modal
    // })
  }
}
