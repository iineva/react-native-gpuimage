# react-native-gpuimage

GPUImage on [react-native](https://github.com/facebook/react-native), iOS use [GPUImage](https://github.com/BradLarson/GPUImage), android use [android-gpuimage](https://github.com/CyberAgent/android-gpuimage)

# Installtion

```shell
npm install git+https://github.com/iineva/react-native-gpuimage
react-native link react-native-gpuimage
```

# Usage

## GPUCameraView

```javascript
import {GPUCameraView} from 'react-native-gpuimage'

const App = ()=>(
  <GPUCameraView
    style={{flex: 1}}
    mirror
    cameraPosition='front'
    filters={[
      'GPUImageRGBFilter',
      'GPUImageToonFilter',
      'GPUImageColorInvertFilter',
      'GPUImageSepiaFilter',
      {
        name: 'GPUImageBrightnessFilter',
        params: {
          brightness: 0.5,
        }
      }
    ]}
  />
)
```

# Available filters

see <https://github.com/BradLarson/GPUImage#built-in-filters>
