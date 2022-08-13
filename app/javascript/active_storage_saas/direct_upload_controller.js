import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "./direct_upload_controller/direct_upload";

const URL = window.URL || window.webkitURL

function setupFilePreview(target, file){
  const onLoaded = function(){
    URL.revokeObjectURL(target.src)
    target.removeEventListener('load', onLoaded)
  }
  target.addEventListener('load', onLoaded)
  target.src = URL.createObjectURL(file)
}
export default class extends Controller {
  static targets = ['file', 'preview'];
  static values = {
    url: String,
  }

  initialize(){
    this.onFileChange = this.onFileChange.bind(this)
  }

  fileTargetConnected(target){
    if(!target.hiddenInput){
      const hiddenInput = document.createElement("input")
      hiddenInput.type = "hidden"
      hiddenInput.name = target.name
      target.insertAdjacentElement("beforebegin", hiddenInput)
      target.removeAttribute('name')
      target.hiddenInput = hiddenInput
    }
    target.addEventListener('change', this.onFileChange)
  }

  fileTargetDisconnected(target){
    target.removeEventListener('change', this.onFileChange)
  }

  onFileChange(event){
    const { target } = event
    const { hiddenInput, files } = target
    const file = files[0]
    if(!file) return

    const directUpload = new DirectUpload(file, this.urlValue, this)

    if(this.hasPreviewTarget){
      setupFilePreview(this.previewTarget, file)
    }

    directUpload.create((error, attributes) => {
      if(error){
        hiddenInput.removeAttribute('value')
      }else{
        hiddenInput.setAttribute('value', attributes.signed_id)
      }
    })
  }

  directUploadWillCreateBlobWithXHR(xhr) {
    this.dispatch("before-blob-request", { detail: xhr })
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.dispatch('started', { detail: xhr })
    this.dispatch('progress', { detail: { percent: 0 } })
    xhr.upload.addEventListener("progress", event => this.uploadRequestDidProgress(event))
  }

  uploadRequestDidProgress(event){
    const percent = event.loaded / event.total
    this.dispatch('progress', { detail: { percent } })
    if(percent == 1){
      this.dispatch('uploaded')
    }
  }
}
