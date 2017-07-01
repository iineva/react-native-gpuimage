import React from 'react'
import {View} from 'react-native'
import PropTypes from 'prop-types'
import { requireNativeComponent } from 'react-native'

const RCTGPUCameraView = requireNativeComponent('RCTGPUCameraView')

export class GPUCameraView extends React.Component {

  static propTypes = {
    style: View.propTypes.style,
    mirror: PropTypes.bool,
    capture: PropTypes.bool,
    cameraPosition: PropTypes.oneOf(['front', 'back']).isRequired,
    filters: PropTypes.arrayOf(PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.shape({
        name: PropTypes.string,
        param: PropTypes.object,
      }),
    ])),
  }

  static defaultProps = {
    capture: true,
  }

  render = ()=>(
    <RCTGPUCameraView {...this.props}/>
  )
}

