import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values  = {queryUrl: String, scheduleCardTemplate: String, scheduleModalTemplate: String}
  static targets = ["results"]

  connect() {
    this.scheduleCardTemplateValue = ``; 
    this.cheduleModalTemplateValue = ``;
    this.show()
  }

  show() {
    fetch(this.queryUrlValue, {headers:{"Accept":"application/json"}}).then(response => response.json()).then(data => {
   
      let schedule_cards_html = ``;
      data.forEach(obj => {
        schedule_cards_html = schedule_cards_html + this.getScheduleCardTemplate(obj) + this.getScheduleModalTemplate(obj);
      })
      this.resultsTarget.innerHTML = schedule_cards_html
    })
  }

  change_schedule_status(event){
    let switch_input    = event.currentTarget;
    let schedule_id     = switch_input.id.replace("status_switch_","")
    let schedule_status = event.currentTarget.value

    fetch("/exchange_rate/schedule_update", {
        method: "post",
        headers:{ "Content-Type":"application/json",
                  "X-CSRF-Token":document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({schedule_id: schedule_id, schedule_status: schedule_status})
        } 
      ).then(response => response.json()).then(data => {
        this.show()
    })
  }

  update_schedule_content(event){
    let edit_confirm_btn = event.currentTarget;
    let schedule_id      = edit_confirm_btn.id.replace("edit_confirm_btn_","")
    let schedule_target_rate     = document.querySelector("#schedule_target_rate_"+schedule_id).value
    let schedule_message_content = document.querySelector("#schedule_message_content_"+schedule_id).value

    fetch("/exchange_rate/schedule_update", {
        method: "post",
        headers:{ "Content-Type":"application/json",
                  "X-CSRF-Token":document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({schedule_id: schedule_id, schedule_target_rate: schedule_target_rate, schedule_message_content: schedule_message_content})
        } 
      ).then(response => response.json()).then(data => {
        this.show()
        document.querySelector("#editorModal_"+schedule_id+" .btn-close").click();
    })

  }

  getScheduleCardTemplate(schedule_obj){
    let schedule_status_tag = ["off",""]
    if (schedule_obj["status"] === "pending") {
      schedule_status_tag = ["on","checked"]
    }
    
    return `
      <div class="card">
      <h5 class="card-header">
        <strong>Bank name:</strong>&nbsp;<em>${schedule_obj["bank_name"]}</em>&nbsp;&nbsp;&nbsp;<strong>Currency:</strong>&nbsp;<em>${schedule_obj["currency"]}</em>&nbsp;&nbsp;&nbsp;<strong>Status:</strong>&nbsp;<em>${schedule_obj["status"]}</em>
      </h5>
      <div class="card-body d-flex">
        <div class="flex-fill d-flex align-items-stretch">
            <div class="d-flex gap-2 m-1">
                <span class="badge bg-primary rounded-pill fs-5 fw-bold py-4 px-2">Current: ${schedule_obj["rate_at_setting"]}</span>
                <span class="badge bg-info rounded-pill fs-5 fw-bold py-4 px-2">Threshold:${schedule_obj["target_rate"]}</span>
            </div>
            <br>
            <div class="d-flex gap-2">
              <a href="#" class="btn btn-success m-1" data-bs-toggle="modal" data-bs-target="#editorModal_${schedule_obj["id"]}">Adjust alert setting</a>
              <div class="form-check form-switch m-1">
                <input class="form-check-input" type="checkbox" role="switch" id="status_switch_${schedule_obj["id"]}" data-action="change->schedule-overview#change_schedule_status" value="${schedule_status_tag[0]}" onchange="this.value = this.checked ? 'on' : 'off'" ${schedule_status_tag[1]}>
                <label class="form-check-label" for="">switch</label>
              </div>
            </div>
        </div>
        <div class="flex-fill d-flex align-items-stretch border">
          <div class="m-4">
            <h5 class="card-title">Message</h5>
            <p class="card-text">${schedule_obj["message_content"]}</p>
          </div>
        </div>
      </div>
        <div class="card-footer text-muted">
        Last Updated Date:${schedule_obj["updated_at"]}
        </div>          
      </div>
      <br>`;
  }

  getScheduleModalTemplate(schedule_obj){
    let edit_maximum = Number(schedule_obj["rate_at_setting"])*1.50;
    let edit_minimum = Number(schedule_obj["rate_at_setting"])/1.50;

    return `
    <div class="modal fade" id="editorModal_${schedule_obj["id"]}" tabindex="-1" aria-labelledby="editorModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-info">
            <h5 class="modal-title">Adjust Preview</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body d-flex">
            <div class="flex-fill">
              <h6 class="card-title">Before Adjust</h6>
              <p class="card-text">
                <div class="mb-3 m-2">
                <textarea class="form-control" rows="5" disabled>${schedule_obj["message_content"]}</textarea>
                </div>
                <div class="mb-3 m-2">
                  <input type="number" class="form-control" value=${schedule_obj["target_rate"]} disabled>
                </div>
              </p>
            </div>
            <div class="flex-fill">
              <h6 class="card-title">After Adjust</h6>
              <p class="card-text">
                <div class="mb-3 m-2">
                  <textarea class="form-control" id="schedule_message_content_${schedule_obj["id"]}" rows="5">${schedule_obj["message_content"]}</textarea>
                </div>
                <div class="mb-3 m-2">
                  <input type="number" class="form-control" id="schedule_target_rate_${schedule_obj["id"]}" value=${schedule_obj["target_rate"]} step="0.01">
                </div>
              </p>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" id="edit_confirm_btn_${schedule_obj["id"]}" class="btn btn-primary" data-action="click->schedule-overview#update_schedule_content">Confirm</button>
          </div>
        </div>
      </div>
      </div>`;
  }

}
