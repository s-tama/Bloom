using UnityEngine;

namespace MyProject
{
    // 輝度抽出用
    public class Brightness : MonoBehaviour
    {
        readonly int ShaderPropertyIDThreshold = Shader.PropertyToID("_Threshold");

        [SerializeField, Range(0, 1)] float _threshold = 1f;

        // 4点サンプリング用
        [SerializeField] Shader _sampleShader = null;
        Material _sampleMaterial;

        void Start()
        {
            _sampleMaterial = new Material(_sampleShader);
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            _sampleMaterial.SetFloat(ShaderPropertyIDThreshold, _threshold);

            Graphics.Blit(src, dest, _sampleMaterial);
        }
    }
}
